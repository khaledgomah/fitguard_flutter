export default function Terms() {
  return (
    <div className="w-full max-w-container-max mx-auto px-margin-mobile md:px-margin-desktop py-16">
      <div className="max-w-3xl mx-auto">
        <h1 className="font-display-lg text-display-lg text-on-surface mb-6">Terms of Service</h1>
        <p className="font-body-lg text-body-lg text-on-surface-variant mb-12">
          Last Updated: {new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
        </p>

        <div className="space-y-8 font-body-md text-body-md text-on-surface-variant">
          <section>
            <h2 className="font-headline-md text-headline-md text-on-surface mb-4">1. Acceptance of Terms</h2>
            <p>
              By accessing and using the FitGuard platform, you accept and agree to be bound by the terms and provision of this agreement. 
              In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.
            </p>
          </section>

          <section>
            <h2 className="font-headline-md text-headline-md text-on-surface mb-4">2. Clinical and Medical Disclaimer</h2>
            <p>
              FitGuard provides AI-driven analytics, biometric tracking, and recovery protocols designed for elite athletic performance. 
              However, the information provided through our platform is for educational and informational purposes only and is not intended 
              as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other 
              qualified health provider with any questions you may have regarding a medical condition or injury.
            </p>
          </section>

          <section>
            <h2 className="font-headline-md text-headline-md text-on-surface mb-4">3. User Accounts</h2>
            <p>
              To access certain features of the platform, you must register for an account. You are responsible for maintaining the confidentiality 
              of your account information, including your password, and for all activity that occurs under your account. You agree to notify us 
              immediately of any unauthorized use of your account or password.
            </p>
          </section>

          <section>
            <h2 className="font-headline-md text-headline-md text-on-surface mb-4">4. Data Privacy and Security</h2>
            <p>
              Your privacy is critical to us. We adhere to strict data protection standards and comply with relevant health data regulations 
              when handling your biometric and injury data. Please review our Privacy Policy, which also governs your use of our Services, 
              to understand our practices.
            </p>
          </section>

          <section>
            <h2 className="font-headline-md text-headline-md text-on-surface mb-4">5. Modifications to Service</h2>
            <p>
              FitGuard reserves the right at any time to modify or discontinue, temporarily or permanently, the Service (or any part thereof) 
              with or without notice. We shall not be liable to you or to any third party for any modification, suspension, or discontinuance of the Service.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
