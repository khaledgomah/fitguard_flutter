export default function About() {
  return (
    <>
      {/* Hero Section */}
      <section className="pt-32 pb-24 px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-gutter items-center">
          <div className="lg:col-span-6 space-y-6">
            <h1 className="font-display-lg text-display-lg text-on-surface">Clinical Precision<br/><span className="text-primary">in Motion.</span></h1>
            <p className="font-body-lg text-body-lg text-on-surface-variant max-w-lg">
              We bridge the gap between high-performance sports technology and rigorous medical science. FitGuard leverages predictive AI to transform biomechanical data into actionable injury prevention strategies.
            </p>
          </div>
          <div className="lg:col-span-6 relative h-[400px] lg:h-[600px] rounded-2xl overflow-hidden bg-surface-container-lowest border border-outline-variant">
            <img 
              alt="Athlete performing high-intensity training with wearable biomechanical sensors in a moody, modern sports laboratory setting." 
              className="absolute inset-0 w-full h-full object-cover grayscale opacity-80 hover:grayscale-0 transition-all duration-700" 
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuBPzW-dC4UcQfC0S5-uxWnHuZWLCJX1du4OVBhCkIJjJltVBQVdP8cRnaZlNVstLmAils1QiZOyn7WichD4L0FNxh5Mq1jewZzmDoeDILL4-wfqZ5dUJnBmXxIsGJzWj5BuJ07fNuP1sJL3qXMqnPpTM3wyT77DeP1DjpvzCvYu-HA7VEk0cLx82l7qzaR7xy7H4mlQ8q3vkaVp68b-7ccgf2264PXZSZGvCLw9gUhChTkwdyiN43l31IF5BXC7OHb3GMEJ-VPcuuc"
            />
          </div>
        </div>
      </section>

      {/* Why FitGuard (Bento Grid) */}
      <section className="py-24 bg-surface-container-low px-margin-mobile md:px-margin-desktop">
        <div className="max-w-container-max mx-auto">
          <div className="mb-16 text-center max-w-2xl mx-auto">
            <h2 className="font-display-md text-display-md mb-4">The Intersection of Tech & Healthcare</h2>
            <p className="font-body-md text-body-md text-on-surface-variant">We don't just track data; we interpret it with clinical rigor. Our platform is built for elite organizations that demand more than just generic fitness metrics.</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-12 gap-6 auto-rows-[300px]">
            {/* Bento Item 1 */}
            <div className="md:col-span-8 bg-surface-container-lowest rounded-xl border border-outline-variant p-8 flex flex-col justify-between group hover:border-outline transition-colors relative overflow-hidden">
              <div className="relative z-10">
                <span className="material-symbols-outlined text-primary text-4xl mb-4">psychology</span>
                <h3 className="font-headline-md text-headline-md mb-2">Predictive AI Engine</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant max-w-md">Our proprietary models analyze micro-deviations in biomechanical load to flag injury risks before physical symptoms manifest.</p>
              </div>
              <div className="absolute bottom-0 right-0 w-1/2 h-full opacity-10 group-hover:opacity-20 transition-opacity">
                <img 
                  alt="Data visualization dashboard showing complex biomechanical algorithms in a dark mode aesthetic." 
                  className="w-full h-full object-cover" 
                  src="https://lh3.googleusercontent.com/aida-public/AB6AXuDl09vklJfLdj2vWwByfInVGxoUTrnIWJyoQK_hWYKj7WMdSeW0uNn_STY0HHOkd1E9d6y3a7rwrqFdzViiCaO2RyUeaGEOYdsFqCXk6MNhZ5gNGlAnOWdqVxA-Ce6MVAbZJgRepFdDcLGB5UAnp5Bo0te-ih5Tm4qV7kNdnIawFD3Stx0zBG_fBJJDa6H_6i0y0RUcCpLRsaG0_CicsrOE_wMX0FFRWJj630E2yXFDNOmf3NegdGIYfBcYuRi6TI19lGJ93lVhjnc"
                />
              </div>
            </div>
            {/* Bento Item 2 */}
            <div className="md:col-span-4 bg-primary text-on-primary rounded-xl p-8 flex flex-col justify-between">
              <div>
                <span className="material-symbols-outlined text-on-primary text-4xl mb-4" style={{ fontVariationSettings: "'FILL' 1" }}>medical_services</span>
                <h3 className="font-headline-md text-headline-md mb-2">Clinical Validation</h3>
                <p className="font-body-sm text-body-sm text-on-primary/80">Developed alongside leading orthopedic surgeons and sports physiotherapists to ensure diagnostic-grade accuracy.</p>
              </div>
            </div>
            {/* Bento Item 3 */}
            <div className="md:col-span-4 bg-surface-container-lowest rounded-xl border border-outline-variant p-8">
              <span className="material-symbols-outlined text-secondary-container text-4xl mb-4">rebase_edit</span>
              <h3 className="font-headline-sm text-headline-sm mb-2">Dynamic Recovery</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">Protocol adjustments made in real-time based on sleep architecture and HRV recovery scores.</p>
            </div>
            {/* Bento Item 4 */}
            <div className="md:col-span-8 bg-surface-container-lowest rounded-xl border border-outline-variant p-8 flex items-center justify-center relative overflow-hidden group">
              <div className="absolute inset-0 bg-gradient-to-r from-surface-container-lowest via-surface-container-lowest/80 to-transparent z-10 p-8 flex flex-col justify-center w-2/3">
                <span className="material-symbols-outlined text-tertiary-container text-4xl mb-4">hub</span>
                <h3 className="font-headline-md text-headline-md mb-2">Ecosystem Integration</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant">Seamlessly syncs with Whoop, Oura, Garmin, and proprietary team force-plate data to create a unified athlete profile.</p>
              </div>
              <div className="absolute inset-0 w-full h-full">
                <img 
                  alt="Medical professional analyzing an athlete's leg with advanced imaging technology." 
                  className="w-full h-full object-cover object-right opacity-60 grayscale group-hover:grayscale-0 transition-all duration-500" 
                  src="https://lh3.googleusercontent.com/aida-public/AB6AXuCjkfkorWR6V8hbNGGOCRhPCtr5lTtoPJ727n9buNt2a15kMdG0PDPMmvQyaqdmaBuAJB8LIxeseApfrqzhf6zGbZEXBh1xbXt-_QryqmpEmfxkv1GG4EI98O5szIG8l8YruSsQyAnoW_ZOhvaAzGl2y8BTZoAl0X11XJLsA4CPaXUPxedVU6G7oADZHUvZ0ZfkSmm1TE7TRj65wu7Q3wlnC1otnn-RJRwta92fMrun3_uRy_eVl13ZUh2RXAAQ1O2cNovuD8_LISk"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Product Story */}
      <section className="py-24 px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto">
        <div className="flex flex-col lg:flex-row gap-16 items-start">
          <div className="lg:w-1/3 sticky top-32">
            <h2 className="font-display-md text-display-md mb-4">The Evolution of Prevention</h2>
            <p className="font-body-md text-body-md text-on-surface-variant">How we moved from reactive treatment to proactive optimization.</p>
          </div>
          <div className="lg:w-2/3 space-y-12">
            {/* Timeline Item 1 */}
            <div className="relative pl-8 border-l border-outline-variant">
              <div className="absolute w-4 h-4 bg-surface border-2 border-primary rounded-full -left-[9px] top-1"></div>
              <h3 className="font-headline-md text-headline-md mb-2">The Data Explosion</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">Teams were drowning in biometric data but lacking context. Wearables tracked everything, but isolated metrics failed to provide a cohesive picture of athlete readiness.</p>
            </div>
            {/* Timeline Item 2 */}
            <div className="relative pl-8 border-l border-outline-variant">
              <div className="absolute w-4 h-4 bg-surface border-2 border-primary rounded-full -left-[9px] top-1"></div>
              <h3 className="font-headline-md text-headline-md mb-2">Introducing the AI Layer</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">We built an intelligent translation layer. By feeding historical injury data and real-time biomechanics into our models, FitGuard began recognizing the invisible patterns that precede soft-tissue injuries.</p>
              <div className="bg-surface-container p-6 rounded-lg border border-outline-variant mt-6 inline-block">
                <div className="flex items-center space-x-3 mb-2">
                  <span className="material-symbols-outlined text-secondary-container">memory</span>
                  <span className="font-label-md text-label-md uppercase text-on-surface">Insight Generation</span>
                </div>
                <p className="font-mono-data text-mono-data text-on-surface-variant">Processing 1.2M data points per athlete per session to calculate acute-to-chronic workload ratios.</p>
              </div>
            </div>
            {/* Timeline Item 3 */}
            <div className="relative pl-8 border-l border-outline-variant border-transparent">
              <div className="absolute w-4 h-4 bg-primary rounded-full -left-[9px] top-1 shadow-[0_0_10px_rgba(16,185,129,0.5)]"></div>
              <h3 className="font-headline-md text-headline-md mb-2">The Standard of Care</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">Today, FitGuard serves as the central nervous system for top-tier athletic organizations, bridging the gap between the weight room, the practice field, and the medical staff.</p>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
