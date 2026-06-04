import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

export const SUPABASE_URL  = 'https://pmoaptlhjytdxgontoss.supabase.co';
export const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtb2FwdGxoanl0ZHhnb250b3NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA1OTMwOTMsImV4cCI6MjA5NjE2OTA5M30.0fAoJm4OVjjz7x6kmKUG8xGVvCdntBTTMgfB2DwU-kA';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON);
