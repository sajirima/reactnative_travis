import AsyncStorage from '@react-native-async-storage/async-storage';
import { useEffect, useState } from 'react';

export type CurrentUser = {
  id: number;
  full_name: string;
  email: string;
  role: string;
  status: string;
};

export function useCurrentUser() {
  const [user, setUser] = useState<CurrentUser | null>(null);

  useEffect(() => {
    AsyncStorage.getItem('user').then((raw) => {
      if (raw) setUser(JSON.parse(raw));
    });
  }, []);

  return user;
}
