import { BrowserRouter as Router, Routes, Route, Outlet } from 'react-router-dom';

// Layouts & Guard
import MarketingLayout from '../components/MarketingLayout';
import AuthLayout from '../components/AuthLayout';
import AppLayout from '../components/AppLayout';
import AuthGuard from '../components/AuthGuard';

// Marketing Pages
import Home from '../pages/Home';
import About from '../pages/About';
import Contact from '../pages/Contact';
import FAQ from '../pages/FAQ';
import Privacy from '../pages/Privacy';
import Terms from '../pages/Terms';

// Auth Pages
import Login from '../pages/Login';
import Register from '../pages/Register';

// App Pages
import Dashboard from '../pages/Dashboard';
import Profile from '../pages/Profile';
import ProfileEdit from '../pages/ProfileEdit';
import Settings from '../pages/Settings';

// Injuries
import InjuryList from '../pages/InjuryList';
import InjuryCreate from '../pages/InjuryCreate';
import InjuryDetails from '../pages/InjuryDetails';
import InjuryEdit from '../pages/InjuryEdit';
import InjuryAnalytics from '../pages/InjuryAnalytics';

// Challenges
import ChallengeHistory from '../pages/ChallengeHistory';
import ChallengeGenerate from '../pages/ChallengeGenerate';
import ActiveChallenge from '../pages/ActiveChallenge';
import ChallengeDetails from '../pages/ChallengeDetails';

// Recovery
import RecoveryProtocolList from '../pages/RecoveryProtocolList';
import RecoveryGenerate from '../pages/RecoveryGenerate';
import ActiveRecovery from '../pages/ActiveRecovery';
import RecoveryDetails from '../pages/RecoveryDetails';

// Notifications
import NotificationCenter from '../pages/NotificationCenter';

export default function AppRoutes() {
  return (
    <Router>
      <Routes>
        {/* Marketing Routes */}
        <Route element={<MarketingLayout><Outlet /></MarketingLayout>}>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/contact" element={<Contact />} />
          <Route path="/faq" element={<FAQ />} />
          <Route path="/privacy" element={<Privacy />} />
          <Route path="/terms" element={<Terms />} />
        </Route>

        {/* Auth Routes */}
        <Route element={<AuthLayout><Outlet /></AuthLayout>}>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
        </Route>

        {/* Protected App Routes */}
        <Route element={
          <AuthGuard>
            <AppLayout>
              <Outlet />
            </AppLayout>
          </AuthGuard>
        }>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/profile/edit" element={<ProfileEdit />} />
          <Route path="/settings" element={<Settings />} />

          <Route path="/injuries" element={<InjuryList />} />
          <Route path="/injuries/create" element={<InjuryCreate />} />
          <Route path="/injuries/analytics" element={<InjuryAnalytics />} />
          <Route path="/injuries/:id" element={<InjuryDetails />} />
          <Route path="/injuries/:id/edit" element={<InjuryEdit />} />

          <Route path="/challenges" element={<ChallengeHistory />} />
          <Route path="/challenges/generate" element={<ChallengeGenerate />} />
          <Route path="/challenges/active" element={<ActiveChallenge />} />
          <Route path="/challenges/:id" element={<ChallengeDetails />} />

          <Route path="/recovery" element={<RecoveryProtocolList />} />
          <Route path="/recovery/generate" element={<RecoveryGenerate />} />
          <Route path="/recovery/active" element={<ActiveRecovery />} />
          <Route path="/recovery/:id" element={<RecoveryDetails />} />

          <Route path="/notifications" element={<NotificationCenter />} />
        </Route>
      </Routes>
    </Router>
  );
}
