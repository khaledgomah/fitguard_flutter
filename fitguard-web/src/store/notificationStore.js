import { create } from 'zustand';
import { notificationService } from '../services/notificationService';

export const useNotificationStore = create((set) => ({
  notifications: [],
  unreadCount: 0,
  loading: false,
  error: null,

  fetchNotifications: async () => {
    set({ loading: true, error: null });
    try {
      const data = await notificationService.getNotifications();
      const unreadCount = data.filter(n => !n.read).length;
      set({ notifications: data, unreadCount, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch notifications', loading: false });
    }
  },

  markRead: async (id) => {
    try {
      await notificationService.markAsRead(id);
      set((state) => {
        const updated = state.notifications.map(n => 
          n.id === id ? { ...n, read: true } : n
        );
        return {
          notifications: updated,
          unreadCount: updated.filter(n => !n.read).length
        };
      });
    } catch (err) {
      console.error('Failed to mark notification as read', err);
    }
  },

  markAllRead: async () => {
    try {
      await notificationService.markAllAsRead();
      set((state) => ({
        notifications: state.notifications.map(n => ({ ...n, read: true })),
        unreadCount: 0
      }));
    } catch (err) {
      console.error('Failed to mark all notifications as read', err);
    }
  },

  deleteNotification: async (id) => {
    try {
      await notificationService.deleteNotification(id);
      set((state) => {
        const filtered = state.notifications.filter(n => n.id !== id);
        return {
          notifications: filtered,
          unreadCount: filtered.filter(n => !n.read).length
        };
      });
    } catch (err) {
      console.error('Failed to delete notification', err);
    }
  }
}));
