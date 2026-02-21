import { toast } from '@/hooks/useToast';

export const showToast = {
  success: (title: string, description?: string) => {
    toast({
      variant: 'success',
      title,
      description,
    });
  },

  error: (title: string, description?: string) => {
    toast({
      variant: 'destructive',
      title,
      description,
    });
  },

  warning: (title: string, description?: string) => {
    toast({
      variant: 'warning',
      title,
      description,
    });
  },

  info: (title: string, description?: string) => {
    toast({
      variant: 'default',
      title,
      description,
    });
  },
};
