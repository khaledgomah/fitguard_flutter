import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useChallengeStore } from '../store/challengeStore';

const generateSchema = z.object({
  difficulty: z.enum(['beginner', 'intermediate', 'advanced'], { required_error: 'Difficulty is required' })
});

export default function ChallengeGenerate() {
  const [isGenerating, setIsGenerating] = useState(false);
  const [loadingTextIndex, setLoadingTextIndex] = useState(0);
  const [serverError, setServerError] = useState('');
  const navigate = useNavigate();
  const { generateChallenge } = useChallengeStore();

  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(generateSchema),
    defaultValues: {
      difficulty: 'intermediate'
    }
  });

  const loadingMessages = [
    "Cross-referencing HRV, sleep architecture, and recent strain metrics to formulate an optimal adaptation plan.",
    "Calibrating intensity thresholds against historical recovery baselines...",
    "Optimizing macro-cycles for peak athletic readiness...",
    "Finalizing clinical precision protocol..."
  ];

  useEffect(() => {
    if (!isGenerating) return;

    const textInterval = setInterval(() => {
      setLoadingTextIndex((prev) => {
        if (prev < loadingMessages.length - 1) return prev + 1;
        return prev;
      });
    }, 2500);

    return () => {
      clearInterval(textInterval);
    };
  }, [isGenerating, loadingMessages.length]);

  const onSubmit = async (data) => {
    try {
      setIsGenerating(true);
      setServerError('');
      await generateChallenge(data);
      navigate('/challenges/active');
    } catch (err) {
      let errorMsg = err.response?.data?.message || 'Failed to generate challenge.';
      if (errorMsg.includes('Invalid input') || errorMsg.includes('expected string')) {
        errorMsg = 'Our AI service experienced a formatting hiccup. Please try generating again.';
      }
      setServerError(errorMsg);
      setIsGenerating(false);
    }
  };

  return (
    <div className="flex-1 p-gutter max-w-container-max mx-auto w-full flex flex-col items-center justify-center relative min-h-[calc(100vh-64px)]">
      
      {!isGenerating ? (
        <form className="w-full max-w-2xl bg-surface-container-lowest border border-outline-variant rounded-xl p-8 flex flex-col shadow-sm transition-opacity duration-300" onSubmit={handleSubmit(onSubmit)}>
          <div className="mb-8 text-center">
            <span className="material-symbols-outlined text-[48px] text-primary mb-4">robot_2</span>
            <h2 className="font-display-md text-display-md text-on-surface mb-2">Generate AI Challenge</h2>
            <p className="font-body-lg text-body-lg text-on-surface-variant">Select a difficulty level to create a custom recovery or performance protocol based on your recent biometric data.</p>
          </div>

          {serverError && (
            <div className="bg-error-container text-error p-3 rounded-xl flex items-center gap-2 mb-6">
              <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
              <span className="font-body-sm text-body-sm">{serverError}</span>
            </div>
          )}
          {errors.difficulty && (
            <p className="text-error text-label-md mb-4 text-center">{errors.difficulty.message}</p>
          )}

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            {/* Beginner */}
            <label className="cursor-pointer relative">
              <input className="peer sr-only" type="radio" value="beginner" {...register('difficulty')} />
              <div className="p-6 border border-outline-variant rounded-xl hover:border-outline peer-checked:border-primary peer-checked:bg-surface-container-low transition-all h-full flex flex-col">
                <span className="material-symbols-outlined text-primary mb-2">hiking</span>
                <span className="font-headline-sm text-headline-sm block mb-1">Beginner</span>
                <span className="font-body-sm text-body-sm text-on-surface-variant">Focus on mobility and light active recovery.</span>
              </div>
            </label>
            {/* Intermediate */}
            <label className="cursor-pointer relative">
              <input className="peer sr-only" type="radio" value="intermediate" {...register('difficulty')} />
              <div className="p-6 border border-outline-variant rounded-xl hover:border-outline peer-checked:border-primary peer-checked:bg-surface-container-low transition-all h-full flex flex-col">
                <span className="material-symbols-outlined text-primary mb-2">directions_run</span>
                <span className="font-headline-sm text-headline-sm block mb-1">Intermediate</span>
                <span className="font-body-sm text-body-sm text-on-surface-variant">Balanced mix of strain and guided rest.</span>
              </div>
            </label>
            {/* Advanced */}
            <label className="cursor-pointer relative">
              <input className="peer sr-only" type="radio" value="advanced" {...register('difficulty')} />
              <div className="p-6 border border-outline-variant rounded-xl hover:border-outline peer-checked:border-primary peer-checked:bg-surface-container-low transition-all h-full flex flex-col">
                <span className="material-symbols-outlined text-primary mb-2">sprint</span>
                <span className="font-headline-sm text-headline-sm block mb-1">Advanced</span>
                <span className="font-body-sm text-body-sm text-on-surface-variant">High-intensity micro-cycles for peak adaptation.</span>
              </div>
            </label>
          </div>
          <button 
            type="submit"
            className="w-full bg-secondary text-white font-headline-sm text-headline-sm py-4 rounded-xl hover:opacity-90 transition-opacity flex items-center justify-center gap-2"
          >
            <span className="material-symbols-outlined text-[20px]">auto_awesome</span>
            Generate Protocol
          </button>
        </form>
      ) : (
        <div className="w-full max-w-2xl flex flex-col items-center justify-center animate-in fade-in duration-500">
          <div className="relative w-32 h-32 flex items-center justify-center mb-8">
            {/* Pulsing Rings */}
            <div className="absolute inset-0 rounded-full border-2 border-secondary animate-[ping_2s_cubic-bezier(0.215,0.61,0.355,1)_infinite]"></div>
            <div className="absolute inset-0 rounded-full border-2 border-secondary animate-[ping_2s_cubic-bezier(0.215,0.61,0.355,1)_infinite]" style={{ animationDelay: '1s' }}></div>
            {/* Core Icon */}
            <div className="relative z-10 w-16 h-16 bg-secondary/10 rounded-full flex items-center justify-center shadow-lg">
              <span className="material-symbols-outlined text-secondary text-[32px] animate-pulse" style={{ fontVariationSettings: "'FILL' 1" }}>memory</span>
            </div>
          </div>
          <h3 className="font-headline-md text-headline-md text-on-surface mb-2">Analyzing Biometric History</h3>
          <p className="font-body-md text-body-md text-on-surface-variant text-center max-w-md mb-8 min-h-[48px] transition-opacity duration-300">
            {loadingMessages[loadingTextIndex]}
          </p>
          
          {/* Data Stream Visualizer */}
          <div className="w-full max-w-md h-24 bg-surface-container-highest rounded-xl overflow-hidden relative flex items-end justify-between px-4 pb-2 border border-outline-variant"
               style={{ background: 'linear-gradient(180deg, transparent, rgba(138, 76, 252, 0.1), transparent)', backgroundSize: '100% 200%', animation: 'data-stream 3s linear infinite' }}>
            <div className="w-2 bg-secondary rounded-t-sm h-[20%] animate-[ping_1.5s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[45%] animate-[ping_2s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[70%] animate-[ping_1.2s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[30%] animate-[ping_2.5s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[85%] animate-[ping_1.8s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[50%] animate-[ping_1.1s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[90%] animate-[ping_2.2s_infinite]"></div>
            <div className="w-2 bg-secondary rounded-t-sm h-[60%] animate-[ping_1.6s_infinite]"></div>
          </div>

          <style>{`
            @keyframes data-stream {
                0% { background-position: 0% -100%; }
                100% { background-position: 0% 100%; }
            }
          `}</style>
        </div>
      )}
    </div>
  );
}
