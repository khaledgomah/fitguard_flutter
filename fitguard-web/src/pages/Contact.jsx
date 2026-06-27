import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useContactStore } from '../store/contactStore';

export default function Contact() {
  const { loading, error, success, submitInquiry, resetStatus } = useContactStore();
  
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    inquiryType: 'Clinical Support',
    message: ''
  });

  useEffect(() => {
    return () => resetStatus();
  }, [resetStatus]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.id]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await submitInquiry(formData);
    if (res) {
      setFormData({
        firstName: '',
        lastName: '',
        email: '',
        inquiryType: 'Clinical Support',
        message: ''
      });
    }
  };

  return (
    <div className="w-full max-w-container-max mx-auto px-margin-mobile md:px-margin-desktop py-12 md:py-24 grid grid-cols-1 md:grid-cols-12 gap-gutter">
      {/* Header Section (Spans full width) */}
      <div className="md:col-span-12 mb-12">
        <h1 className="font-display-lg text-display-lg text-on-surface mb-4">Get in touch.</h1>
        <p className="font-body-lg text-body-lg text-on-surface-variant max-w-2xl">
          Whether you're an elite athlete, a sports medicine professional, or looking for enterprise solutions, our team is ready to assist with clinical precision.
        </p>
      </div>

      {/* Contact Form Card */}
      <div className="md:col-span-7 bg-surface-container-lowest border border-outline-variant rounded-xl p-8 relative overflow-hidden">
        {/* Subtle atmospheric gradient in background */}
        <div className="absolute -top-24 -right-24 w-64 h-64 bg-primary/5 rounded-full blur-3xl pointer-events-none"></div>
        <h2 className="font-headline-sm text-headline-sm text-on-surface mb-6 relative z-10">Send a Message</h2>
        
        {success ? (
          <div className="relative z-10 bg-primary-container/20 border border-primary text-on-primary-container p-6 rounded-lg mb-6 flex flex-col items-center text-center">
            <span className="material-symbols-outlined text-4xl mb-4 text-primary">check_circle</span>
            <h3 className="font-headline-sm text-headline-sm mb-2">Message Sent</h3>
            <p className="font-body-md text-body-md">Thank you for reaching out. Our team will get back to you shortly.</p>
            <button 
              onClick={resetStatus}
              className="mt-6 font-label-md text-label-md bg-primary text-on-primary px-6 py-2 rounded hover:bg-primary-container hover:text-on-primary-container transition-colors"
            >
              Send Another
            </button>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-6 relative z-10">
            {error && (
              <div className="bg-error-container text-on-error-container p-4 rounded-md font-body-sm text-body-sm">
                {error}
              </div>
            )}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="block font-label-md text-label-md text-on-surface" htmlFor="firstName">First Name</label>
                <input 
                  required
                  className="w-full bg-surface border border-outline-variant rounded p-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors" 
                  id="firstName" 
                  type="text"
                  value={formData.firstName}
                  onChange={handleChange}
                />
              </div>
              <div className="space-y-2">
                <label className="block font-label-md text-label-md text-on-surface" htmlFor="lastName">Last Name</label>
                <input 
                  required
                  className="w-full bg-surface border border-outline-variant rounded p-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors" 
                  id="lastName" 
                  type="text"
                  value={formData.lastName}
                  onChange={handleChange}
                />
              </div>
            </div>
            <div className="space-y-2">
              <label className="block font-label-md text-label-md text-on-surface" htmlFor="email">Work Email</label>
              <input 
                required
                className="w-full bg-surface border border-outline-variant rounded p-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors" 
                id="email" 
                type="email"
                value={formData.email}
                onChange={handleChange}
              />
            </div>
            <div className="space-y-2">
              <label className="block font-label-md text-label-md text-on-surface" htmlFor="inquiryType">Inquiry Type</label>
              <select 
                className="w-full bg-surface border border-outline-variant rounded p-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary appearance-none transition-colors" 
                id="inquiryType"
                value={formData.inquiryType}
                onChange={handleChange}
              >
                <option>Clinical Support</option>
                <option>Enterprise Sales</option>
                <option>Partnerships</option>
                <option>General Inquiry</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="block font-label-md text-label-md text-on-surface" htmlFor="message">Message</label>
              <textarea 
                required
                className="w-full bg-surface border border-outline-variant rounded p-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors" 
                id="message" 
                rows="4"
                value={formData.message}
                onChange={handleChange}
              ></textarea>
            </div>
            <button 
              disabled={loading}
              className="w-full bg-primary text-on-primary font-label-md text-label-md font-bold py-4 rounded hover:bg-primary-container hover:text-on-primary-container transition-colors flex items-center justify-center space-x-2 disabled:opacity-70 disabled:cursor-not-allowed" 
              type="submit"
            >
              <span>{loading ? 'Submitting...' : 'Submit Inquiry'}</span>
              {!loading && <span className="material-symbols-outlined text-[18px]">arrow_forward</span>}
            </button>
          </form>
        )}
      </div>

      {/* Sidebar Information */}
      <div className="md:col-span-5 space-y-8 flex flex-col">
        {/* Contact Info Bento Block */}
        <div className="bg-surface-container border border-outline-variant rounded-xl p-8 flex-grow">
          <h3 className="font-headline-sm text-headline-sm text-on-surface mb-6">Direct Channels</h3>
          <div className="space-y-6">
            <div className="flex items-start space-x-4">
              <div className="bg-surface p-2 rounded border border-outline-variant">
                <span className="material-symbols-outlined text-primary">mail</span>
              </div>
              <div>
                <p className="font-label-md text-label-md text-on-surface-variant mb-1">Support Email</p>
                <p className="font-body-md text-body-md text-on-surface font-medium">support@fitguard.ai</p>
              </div>
            </div>
            <div className="flex items-start space-x-4">
              <div className="bg-surface p-2 rounded border border-outline-variant">
                <span className="material-symbols-outlined text-primary">location_on</span>
              </div>
              <div>
                <p className="font-label-md text-label-md text-on-surface-variant mb-1">Headquarters</p>
                <p className="font-body-md text-body-md text-on-surface font-medium">100 Innovation Way<br/>Performance District, CA 94016</p>
              </div>
            </div>


          </div>
        </div>
      </div>
    </div>
  );
}
