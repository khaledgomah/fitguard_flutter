const XAI_BASE_URL = process.env.XAI_BASE_URL || 'https://api.x.ai/v1';
const XAI_MODEL = process.env.XAI_MODEL || 'grok-2';

const hasApiKey = () => !!process.env.XAI_API_KEY;

async function makeXaiRequest(messages, options = {}) {
  const apiKey = process.env.XAI_API_KEY;
  if (!apiKey) {
    throw new Error('XAI_API_KEY is not configured. Please add it to your environment variables.');
  }

  const { timeout, ...restOptions } = options;
  const baseUrlCleaned = XAI_BASE_URL.replace(/\/$/, '');
  const url = `${baseUrlCleaned}/chat/completions`;
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    },
    body: JSON.stringify({
      model: XAI_MODEL,
      messages,
      response_format: { type: 'json_object' },
      temperature: 0.2,
      max_tokens: 4000,
      ...restOptions
    }),
    signal: timeout ? AbortSignal.timeout(timeout) : undefined
  });

  if (!response.ok) {
    const errorBody = await response.text().catch(() => '');
    throw new Error(`xAI API returned status ${response.status}: ${errorBody || response.statusText}`);
  }

  return response.json();
}

function parseCleanJson(text) {
  let cleaned = text.trim();
  if (cleaned.startsWith('```')) {
    cleaned = cleaned.replace(/^```(json)?/, '').replace(/```$/, '').trim();
  }
  try {
    return JSON.parse(cleaned);
  } catch (error) {
    console.error('Failed to parse AI response as JSON. Raw text:', text);
    throw new Error('AI generated invalid JSON structure. Please try again.');
  }
}

// Prompt Helper Functions
function getChallengeSystemPrompt() {
  return `You are FitGuard's expert AI Sports Trainer. Your goal is to generate a personalized 30-day progressive training plan for an athlete.
You will receive a context object containing their target sport, requested difficulty, injury history, recurring injuries, and active injuries.

CRITICAL SAFETY RULES:
1. AVOID exercises that stress actively injured muscle groups listed under "activeInjuries". Focus on safe alternatives or non-impact work for those areas.
2. INCLUDE target strengthening, stability, and mobility exercises for repeatedly injured muscle groups listed under "recurringInjuries" to rehabilitate and protect them.
3. The generated plan must consist of EXACTLY 30 days. No more, no less. You MUST output exactly 30 day objects.
4. You must output ONLY a valid JSON object matching the schema below. No explanations, no conversation, and no markdown wrapper (except the JSON format itself).

Expected JSON schema:
{
  "days": [
    {
      "day": 1,
      "task": "Perform a 5-minute light jog, 3 sets of 10 glute bridges, 3 sets of 12 bodyweight squats. Focus on core activation.",
      "muscleGroups": ["hamstrings", "glutes", "core"],
      "difficulty": "intermediate",
      "exercises": [
        {
          "title": "Bodyweight Squats",
          "description": "Keep chest up and knees behind toes.",
          "sets": 3,
          "reps": 12,
          "duration": null
        }
      ]
    }
  ]
}
Each day must specify a "day" number, a detailed "task" string, an array of targeted "muscleGroups", and the "difficulty" level. You must provide all 30 days from day 1 to day 30 sequentially.`;
}

function getChallengeUserPrompt(context) {
  return `Generate the 30-day challenge plan based on this athlete context:
${JSON.stringify(context, null, 2)}`;
}

function getRecoverySystemPrompt() {
  return `You are FitGuard's AI Sports Rehabilitation Specialist. Your goal is to generate a phased return-to-play recovery protocol for an athlete's specific injury.
You will receive the injury details and the athlete's full injury history context.

CRITICAL Rehab RULES:
1. Design a progressive return-to-play protocol with sequential phases (e.g., 3 to 4 phases).
2. Avoid exercises stressing other actively injured muscle groups while rehabilitating the current injury.
3. For each phase, specify the phaseNumber, name of the phase, duration in days, and a list of specific recovery exercises.
4. You must output ONLY a valid JSON object matching the schema below. No explanations, no conversation, and no markdown wrapper (except the JSON format itself).

Expected JSON schema:
{
  "goal": "Return to play within 6 weeks",
  "target": "Full range of motion and weight bearing",
  "phases": [
    {
      "phaseNumber": 1,
      "name": "Initial Rest and Range of Motion",
      "durationDays": 7,
      "exercises": [
        {
          "title": "Ankle alphabet drawing in air",
          "description": "Draw A-Z with big toe.",
          "sets": 3,
          "reps": 2,
          "duration": null
        },
        {
          "title": "Seated calf stretch with towel",
          "description": "Keep knee straight.",
          "sets": 3,
          "reps": 1,
          "duration": "30s"
        }
      ]
    }
  ]
}`;
}

function getRecoveryUserPrompt(injuryLog, context) {
  return `Generate the phased recovery protocol for this injury:
${JSON.stringify(injuryLog, null, 2)}

Athlete context:
${JSON.stringify(context, null, 2)}`;
}

function generateMockChallenge(context) {
  const sport = context.sport || 'General Fitness';
  const difficulty = context.difficulty || 'intermediate';

  const activeMuscles = (context.activeInjuries || []).map(i => i.muscleGroup.toLowerCase());
  const recurringMuscles = (context.recurringInjuries || []).map(i => i.muscleGroup.toLowerCase());

  const days = [];
  for (let d = 1; d <= 30; d++) {
    let targeted = ['core', 'cardio'];
    let task = '';

    if (d % 3 === 1) {
      targeted = ['legs', 'lower body'];
      const isLegInjured = activeMuscles.some(m =>
        m.includes('leg') || m.includes('hamstring') || m.includes('knee') || m.includes('ankle') || m.includes('calf') || m.includes('quad')
      );
      if (isLegInjured) {
        task = `Light upper-body mobility and core hold (Plank 3 sets of 30s). Leg exercises avoided due to active injury in: ${activeMuscles.join(', ')}.`;
        targeted = ['core', 'shoulders'];
      } else {
        task = `Do 3 sets of 12 bodyweight squats, 3 sets of 10 lunges.`;
        const hasRecurringHamstring = recurringMuscles.some(m => m.includes('hamstring') || m.includes('leg'));
        if (hasRecurringHamstring) {
          task += ` Include 3 sets of 10 glute bridges to target hamstring strengthening.`;
          targeted.push('hamstrings');
        }
      }
    } else if (d % 3 === 2) {
      targeted = ['arms', 'upper body'];
      const isUpperInjured = activeMuscles.some(m =>
        m.includes('arm') || m.includes('shoulder') || m.includes('wrist') || m.includes('chest') || m.includes('elbow')
      );
      if (isUpperInjured) {
        task = `Lower-body stretching, 3 sets of 15 calf raises. Upper-body work skipped due to active injury in: ${activeMuscles.join(', ')}.`;
        targeted = ['legs', 'calves'];
      } else {
        task = `3 sets of 8 pushups, 3 sets of 12 arm circles, 3 sets of 10 dumbbell rows.`;
      }
    } else {
      targeted = ['cardio', 'endurance'];
      task = `Perform 20 minutes of steady state cardio (brisk walk, stationary cycle or light jog targeting ${sport} prep).`;
    }

    days.push({
      day: d,
      task: `[Day ${d}] ${task} Level: ${difficulty}.`,
      muscleGroups: targeted,
      difficulty: difficulty,
      exercises: [
        {
          title: "Mock Exercise",
          description: task,
          sets: 3,
          reps: 10,
          duration: null
        }
      ]
    });
  }

  return { days };
}

function generateMockRecoveryProtocol(injuryLog, context) {
  const muscle = injuryLog.muscleGroup || 'injured area';
  const type = injuryLog.injuryType || 'injury';

  return {
    goal: `Return to full sport performance safely`,
    target: `Restore 100% ${muscle} mobility and strength`,
    phases: [
      {
        phaseNumber: 1,
        name: `Rest & Gentle Mobility for ${muscle} ${type}`,
        durationDays: 7,
        exercises: [
          {
            title: `Gentle passive stretching of the ${muscle}`,
            description: "Hold gently without pain.",
            sets: 3,
            reps: 1,
            duration: "15s"
          },
          {
            title: "RICE treatment protocol",
            description: "Rest, Ice, Compress, Elevate.",
            sets: 1,
            reps: 1,
            duration: "20m"
          }
        ]
      },
      {
        phaseNumber: 2,
        name: `Active Movement & Stability`,
        durationDays: 10,
        exercises: [
          {
            title: `Active ranges of motion for ${muscle}`,
            description: "No weight.",
            sets: 3,
            reps: 15,
            duration: null
          },
          {
            title: "Core alignment planks",
            description: "Maintain straight back.",
            sets: 3,
            reps: 1,
            duration: "30s"
          }
        ]
      },
      {
        phaseNumber: 3,
        name: `Progressive Strengthening & Return to ${context.sport || 'play'}`,
        durationDays: 14,
        exercises: [
          {
            title: `Resisted concentric exercises for ${muscle}`,
            description: "Use resistance band.",
            sets: 3,
            reps: 8,
            duration: null
          }
        ]
      }
    ]
  };
}

function ensureThirtyDays(aiResult, context) {
  if (!aiResult || typeof aiResult !== 'object') {
    aiResult = {};
  }
  
  if (!Array.isArray(aiResult.days)) {
    aiResult.days = [];
  }

  let days = aiResult.days.filter(d => d && typeof d === 'object');

  if (days.length === 0) {
    console.warn('[AI Repair Mode]: No valid days array returned by AI. Falling back to mock.');
    return generateMockChallenge(context);
  }

  if (days.length !== 30) {
    console.warn(`[AI Repair Mode]: AI returned ${days.length} days instead of 30. Restructuring/padding to exactly 30 days.`);
  }

  // Ensure day numbers are sequential and valid
  days.forEach((d, idx) => {
    if (typeof d.day !== 'number' || isNaN(d.day)) {
      d.day = idx + 1;
    }
  });

  days.sort((a, b) => a.day - b.day);

  const targetLength = 30;
  const finalDays = [];

  for (let i = 1; i <= targetLength; i++) {
    const sourceDay = days[(i - 1) % days.length];

    const clonedExercises = Array.isArray(sourceDay.exercises)
      ? JSON.parse(JSON.stringify(sourceDay.exercises))
      : [];

    finalDays.push({
      day: i,
      task: sourceDay.task || `Perform core stability and light mobility exercises for athletic development.`,
      muscleGroups: Array.isArray(sourceDay.muscleGroups) ? [...sourceDay.muscleGroups] : ['core', 'mobility'],
      difficulty: sourceDay.difficulty || context.difficulty || 'intermediate',
      exercises: clonedExercises
    });
  }

  return {
    ...aiResult,
    days: finalDays
  };
}

async function generateChallenge(context) {
  if (!hasApiKey()) {
    console.warn('[AI Mock Mode]: XAI_API_KEY is missing. Generating a mocked 30-day challenge plan.');
    return generateMockChallenge(context);
  }

  try {
    const responseData = await makeXaiRequest([
      { role: 'system', content: getChallengeSystemPrompt() },
      { role: 'user', content: getChallengeUserPrompt(context) }
    ], { timeout: 30000 });

    const contentText = responseData.choices[0].message.content;
    const parsed = parseCleanJson(contentText);
    return ensureThirtyDays(parsed, context);
  } catch (error) {
    console.warn('xAI challenge generation failed, falling back to mock data:', error.message);
    return generateMockChallenge(context);
  }
}

async function generateRecoveryProtocol(injuryLog, context) {
  if (!hasApiKey()) {
    console.warn('[AI Mock Mode]: XAI_API_KEY is missing. Generating a mocked recovery protocol.');
    return generateMockRecoveryProtocol(injuryLog, context);
  }

  try {
    const responseData = await makeXaiRequest([
      { role: 'system', content: getRecoverySystemPrompt() },
      { role: 'user', content: getRecoveryUserPrompt(injuryLog, context) }
    ], { timeout: 15000 });

    const contentText = responseData.choices[0].message.content;
    return parseCleanJson(contentText);
  } catch (error) {
    console.warn('xAI recovery protocol generation failed, falling back to mock data:', error.message);
    return generateMockRecoveryProtocol(injuryLog, context);
  }
}

module.exports = {
  generateChallenge,
  generateRecoveryProtocol
};
