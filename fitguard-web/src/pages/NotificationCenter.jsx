import { useEffect } from 'react';
import { useNotificationStore } from '../store/notificationStore';

export default function NotificationCenter() {
  const { notifications, unreadCount, fetchNotifications, markAllRead, markRead, deleteNotification } = useNotificationStore();

  useEffect(() => {
    fetchNotifications();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  const aiInsightsCount = notifications.filter(n => n.type === 'challenge_nudge' && !n.read).length;

  return (
    <div className="flex-1 p-margin-desktop max-w-container-max mx-auto w-full">
      {/* Page Header */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h2 className="font-display-md text-display-md text-on-surface tracking-tight">Notification Center</h2>
          <p className="font-body-lg text-body-lg text-on-surface-variant mt-2">Manage your recovery alerts, insights, and system updates.</p>
        </div>
        <button 
          onClick={markAllRead}
          className="font-label-md text-label-md text-primary hover:text-surface-tint flex items-center transition-colors"
        >
          <span className="material-symbols-outlined mr-1 text-[16px]">done_all</span>
          Mark all as read
        </button>
      </div>

      {/* Bento Layout for Notifications */}
      <div className="grid grid-cols-12 gap-gutter">
        {/* Left Column: Filters/Categories (4 cols) */}
        <div className="col-span-12 md:col-span-4 lg:col-span-3">
          <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-4 sticky top-[96px]">
            <h3 className="font-headline-sm text-headline-sm text-on-surface mb-4">Categories</h3>
            <nav className="flex flex-col space-y-1">
              <button className="flex items-center justify-between w-full px-3 py-2.5 rounded-lg bg-surface-container text-on-surface font-body-md text-body-md text-left">
                <span className="flex items-center">
                  <span className="material-symbols-outlined mr-3 text-on-surface-variant text-[20px]">inbox</span>
                  All Notifications
                </span>
                {unreadCount > 0 && <span className="bg-surface-variant text-on-surface-variant text-xs px-2 py-0.5 rounded-full font-mono-data">{unreadCount}</span>}
              </button>
              <button className="flex items-center justify-between w-full px-3 py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-body-md text-body-md text-left transition-colors">
                <span className="flex items-center">
                  <span className="material-symbols-outlined mr-3 text-emerald-600 text-[20px]">vital_signs</span>
                  Recovery Reminders
                </span>
              </button>
              <button className="flex items-center justify-between w-full px-3 py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-body-md text-body-md text-left transition-colors">
                <span className="flex items-center">
                  <span className="material-symbols-outlined mr-3 text-secondary text-[20px]">smart_toy</span>
                  AI Insights
                </span>
                {aiInsightsCount > 0 && <span className="bg-secondary-fixed text-on-secondary-fixed text-xs px-2 py-0.5 rounded-full font-mono-data">{aiInsightsCount}</span>}
              </button>
              <button className="flex items-center justify-between w-full px-3 py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-body-md text-body-md text-left transition-colors">
                <span className="flex items-center">
                  <span className="material-symbols-outlined mr-3 text-rose-500 text-[20px]">warning</span>
                  System Alerts
                </span>
              </button>
            </nav>
          </div>
        </div>

        {/* Right Column: List (8 cols) */}
        <div className="col-span-12 md:col-span-8 lg:col-span-9 space-y-4">
          {notifications.length === 0 ? (
            <div className="text-center p-12 text-on-surface-variant bg-surface-container-lowest border border-outline-variant rounded-xl">
              <span className="material-symbols-outlined text-[48px] mb-4 opacity-50">notifications_off</span>
              <p className="font-body-lg text-body-lg">You have no notifications at this time.</p>
            </div>
          ) : (
            notifications.map((notification) => {
              const isUnread = !notification.read;
              const date = new Date(notification.createdAt);
              const dateString = date.toLocaleDateString();
              const timeString = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

              let icon = 'info';
              let iconColor = 'text-blue-500';
              let bgColor = 'bg-blue-50';
              let tagText = 'Info';
              let tagColor = 'text-blue-700 bg-blue-50';

              if (notification.type === 'injury_reminder') {
                icon = 'warning';
                iconColor = 'text-rose-500';
                bgColor = 'bg-rose-50';
                tagText = 'Alert';
                tagColor = 'text-rose-600 bg-rose-50';
              } else if (notification.type === 'recovery_reminder') {
                icon = 'water_drop';
                iconColor = 'text-emerald-600';
                bgColor = 'bg-emerald-50';
                tagText = 'Recovery';
                tagColor = 'text-emerald-700 bg-emerald-50';
              } else if (notification.type === 'challenge_nudge') {
                icon = 'auto_awesome';
                iconColor = 'text-secondary';
                bgColor = 'bg-violet-50';
                tagText = 'AI Insight';
                tagColor = 'text-secondary bg-violet-50';
              }
              
              const title = notification.title || (notification.type === 'injury_reminder' ? 'Injury Alert' : notification.type === 'recovery_reminder' ? 'Recovery Update' : 'Challenge Update');

              return (
                <div 
                  key={notification.id} 
                  onClick={() => { if (isUnread) markRead(notification.id); }}
                  className={`bg-surface-container-lowest border border-outline-variant rounded-xl p-6 relative overflow-hidden group hover:border-outline transition-colors cursor-pointer ${isUnread ? '' : 'opacity-75 hover:opacity-100'}`}
                >
                  {isUnread && <div className="absolute left-0 top-0 bottom-0 w-1 bg-secondary"></div>}
                  <div className="flex items-start">
                    <div className={`w-10 h-10 rounded-full ${bgColor} flex items-center justify-center mr-4 flex-shrink-0`}>
                      <span className={`material-symbols-outlined ${iconColor} text-[20px]`}>{icon}</span>
                    </div>
                    <div className="flex-1">
                      <div className="flex justify-between items-start mb-1">
                        <div className="flex items-center space-x-2">
                          <span className={`${tagColor} font-label-md text-label-md px-2 py-0.5 rounded-sm`}>{tagText}</span>
                          <h5 className="font-headline-sm text-headline-sm text-on-surface">{title}</h5>
                        </div>
                        <span className="font-mono-data text-mono-data text-on-surface-variant text-sm">{dateString} {timeString}</span>
                      </div>
                      <p className="font-body-md text-body-md text-on-surface-variant leading-relaxed">
                        {notification.message}
                      </p>
                    </div>
                    <button onClick={(e) => { e.stopPropagation(); deleteNotification(notification.id); }} className="ml-4 text-on-surface-variant hover:text-error transition-colors">
                      <span className="material-symbols-outlined">delete</span>
                    </button>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}
