import { useState } from 'react';

function AccordionItem({ title, content, isPrimary = false }) {
  const [isActive, setIsActive] = useState(false);

  // Use dynamic border color based on the section
  const borderClasses = isPrimary 
    ? 'border-secondary/20 hover:bg-secondary-fixed/10' 
    : 'border-outline-variant hover:bg-surface-container-low';

  return (
    <div className={`accordion-item bg-surface-container-lowest border ${isPrimary ? 'border-secondary/20' : 'border-outline-variant'} rounded-xl overflow-hidden cursor-pointer relative ${isActive ? 'active' : ''}`} onClick={() => setIsActive(!isActive)}>
      {isPrimary && (
        <div className={`absolute left-0 top-0 bottom-0 w-1 bg-secondary ${isActive ? '' : 'opacity-30'}`}></div>
      )}
      <div className={`flex justify-between items-center p-6 transition-colors ${borderClasses}`}>
        <h3 className="font-headline-sm text-headline-sm text-on-surface">{title}</h3>
        <span className={`material-symbols-outlined accordion-icon ${isPrimary ? 'text-secondary' : 'text-outline'}`}>expand_more</span>
      </div>
      <div className="accordion-content px-6 bg-surface-container-lowest text-on-surface-variant font-body-md text-body-md border-t border-outline-variant">
        {content}
      </div>
    </div>
  );
}

export default function FAQ() {
  const scrollToSection = (id) => {
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div className="w-full max-w-container-max mx-auto px-margin-mobile md:px-margin-desktop py-16">
      {/* Header */}
      <div className="text-center mb-16 max-w-2xl mx-auto">
        <h1 className="font-display-lg text-display-lg text-on-surface mb-6">Frequently Asked Questions</h1>
        <p className="font-body-lg text-body-lg text-on-surface-variant">Everything you need to know about FitGuard's clinical precision recovery platform and AI-driven insights.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-12 gap-8 lg:gap-12">
        {/* Sidebar Navigation */}
        <div className="col-span-1 md:col-span-3 lg:col-span-3">
          <div className="sticky top-[100px] space-y-2">
            <button onClick={() => scrollToSection('general')} className="w-full text-left px-4 py-3 rounded-lg bg-surface-container-low text-primary font-label-md text-label-md font-bold border-l-4 border-primary transition-all">General Questions</button>
            <button onClick={() => scrollToSection('injury')} className="w-full text-left px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-lowest font-label-md text-label-md font-medium border-l-4 border-transparent hover:border-outline-variant transition-all">Injury Tracking</button>
            <button onClick={() => scrollToSection('ai-recovery')} className="w-full text-left px-4 py-3 rounded-lg text-secondary hover:bg-secondary-fixed/20 font-label-md text-label-md font-bold border-l-4 border-transparent hover:border-secondary transition-all">AI Recovery Protocols</button>
            <button onClick={() => scrollToSection('pricing')} className="w-full text-left px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-lowest font-label-md text-label-md font-medium border-l-4 border-transparent hover:border-outline-variant transition-all">Subscription & Pricing</button>
          </div>
        </div>

        {/* FAQ Content */}
        <div className="col-span-1 md:col-span-9 lg:col-span-8 lg:col-start-5 space-y-12">
          
          {/* Section: General */}
          <section id="general">
            <h2 className="font-headline-md text-headline-md text-on-surface border-b border-outline-variant pb-4 mb-6">General Questions</h2>
            <div className="space-y-4">
              <AccordionItem 
                title="What is FitGuard?"
                content="FitGuard is a clinical-grade biometric platform designed for elite athletes and performance professionals. It aggregates data from wearables to provide actionable insights for injury prevention and optimized recovery."
              />
              <AccordionItem 
                title="Which wearables are supported?"
                content="Currently, we support direct integrations with Whoop, Oura, Garmin, and Apple Health. Our API allows for custom integrations for enterprise professional teams."
              />
            </div>
          </section>

          {/* Section: Injury Tracking */}
          <section id="injury">
            <h2 className="font-headline-md text-headline-md text-on-surface border-b border-outline-variant pb-4 mb-6">Injury Tracking</h2>
            <div className="space-y-4">
              <AccordionItem 
                title="How do I log an injury?"
                content="You can log an injury through your dashboard by selecting the affected area, severity, and current status. Our platform then tracks your recovery progress and adjusts your protocols."
              />
            </div>
          </section>

          {/* Section: AI Recovery */}
          <section id="ai-recovery">
            <div className="flex items-center space-x-3 border-b border-secondary/30 pb-4 mb-6">
              <span className="material-symbols-outlined text-secondary" style={{ fontVariationSettings: "'FILL' 1" }}>smart_toy</span>
              <h2 className="font-headline-md text-headline-md text-secondary">AI Recovery Protocols</h2>
            </div>
            <div className="space-y-4">
              <AccordionItem 
                isPrimary={true}
                title="How does the AI determine my recovery plan?"
                content="Our proprietary machine learning models analyze your HRV, resting heart rate, sleep architecture, and training load to generate a daily readiness score. Based on this score, the AI prescribes specific recovery modalities such as active recovery zones, heat therapy, or complete rest."
              />
              <AccordionItem 
                isPrimary={true}
                title="Can the AI predict injuries?"
                content="While we cannot predict injuries with 100% certainty, our AI identifies patterns of accumulated fatigue and biomechanical stress that statistically precede soft tissue injuries. When these patterns emerge, the system flags a 'High Risk' status and suggests immediate intervention."
              />
            </div>
          </section>

          {/* Section: Pricing */}
          <section id="pricing">
            <h2 className="font-headline-md text-headline-md text-on-surface border-b border-outline-variant pb-4 mb-6">Subscription & Pricing</h2>
            <div className="space-y-4">
              <AccordionItem 
                title="Is there a free trial for the Pro plan?"
                content="Yes, we offer a 14-day clinical trial for individual athletes and a 30-day pilot program for professional organizations to validate the data accuracy against their current systems."
              />
            </div>
          </section>

        </div>
      </div>
    </div>
  );
}
