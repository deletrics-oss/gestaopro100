import { createContext, useContext, useState, useCallback, ReactNode, useEffect } from 'react';
import { supabase } from '@/lib/supabase';

type AlertMode = 'disabled' | 'on-order' | 'interval';
type AudioSource = 'server' | 'local';
type SoundType = 'novo_pedido' | 'pedido_concluido' | 'atencao_maquina' | 'compareca_direcao' | 'estoque_baixo';

interface SoundAlertContextType {
  alertMode: AlertMode;
  audioSource: AudioSource;
  setAlertMode: (mode: AlertMode) => void;
  setAudioSource: (source: AudioSource) => void;
  playAlert: (type: SoundType) => void;
  playManualAudio: (name: string) => void;
  testSound: () => void;
  selectedSounds: Record<string, SoundType>;
  setSelectedSound: (context: string, sound: SoundType) => void;
}

const SoundAlertContext = createContext<SoundAlertContextType | undefined>(undefined);

const DEFAULT_SOUNDS: Record<string, SoundType> = {
  'marketplace_new': 'novo_pedido',
  'marketplace_complete': 'pedido_concluido',
  'monitor_external': 'atencao_maquina',
  'stock_alert': 'estoque_baixo',
};

export function SoundAlertProvider({ children }: { children: ReactNode }) {
  const [alertMode, setAlertModeState] = useState<AlertMode>('on-order');
  const [audioSource, setAudioSourceState] = useState<AudioSource>('server');
  const [selectedSounds, setSelectedSoundsState] = useState<Record<string, SoundType>>(DEFAULT_SOUNDS);
  const [isLoaded, setIsLoaded] = useState(false);

  // Carregar configurações do banco de dados
  useEffect(() => {
    const loadSettings = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const { data, error } = await supabase
        .from('audio_settings')
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (data && !error) {
        setAlertModeState(data.alert_mode as AlertMode);
        setAudioSourceState(data.audio_source as AudioSource);
        setSelectedSoundsState(data.selected_sounds as Record<string, SoundType>);
      }
      setIsLoaded(true);
    };

    loadSettings();
  }, []);

  const saveSettings = useCallback(async (updates: Partial<{
    alert_mode: AlertMode;
    audio_source: AudioSource;
    selected_sounds: Record<string, SoundType>;
  }>) => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;

    const { error } = await supabase
      .from('audio_settings')
      .upsert({
        user_id: user.id,
        alert_mode: updates.alert_mode || alertMode,
        audio_source: updates.audio_source || audioSource,
        selected_sounds: updates.selected_sounds || selectedSounds,
      });

    if (error) console.error('Erro ao salvar configurações:', error);
  }, [alertMode, audioSource, selectedSounds]);

  const setAlertMode = useCallback((mode: AlertMode) => {
    setAlertModeState(mode);
    saveSettings({ alert_mode: mode });
  }, [saveSettings]);

  const setAudioSource = useCallback((source: AudioSource) => {
    setAudioSourceState(source);
    saveSettings({ audio_source: source });
  }, [saveSettings]);

  const setSelectedSound = useCallback((context: string, sound: SoundType) => {
    setSelectedSoundsState(prev => {
      const updated = { ...prev, [context]: sound };
      saveSettings({ selected_sounds: updated });
      return updated;
    });
  }, [saveSettings]);

  const playManualAudio = useCallback((name: string) => {
    try {
      const audioKey = `manual_audio_${name}`;
      const audioData = localStorage.getItem(audioKey);
      
      if (!audioData) {
        console.error('Audio not found:', name);
        return;
      }

      const audio = new Audio(audioData);
      audio.play().catch((err) => console.log('Manual audio play failed:', err));
    } catch (error) {
      console.error('Error playing manual audio:', error);
    }
  }, []);

  const playAlert = useCallback((type: SoundType) => {
    if (alertMode === 'disabled') return;

    try {
      if (audioSource === 'local') {
        const preferredAudio = localStorage.getItem('preferred_alert_manual_audio');
        if (preferredAudio) {
          playManualAudio(preferredAudio);
          return;
        }
      }

      // Som padrão do servidor
      const audio = new Audio(`/sounds/${type}.mp3`);
      audio.volume = 1.0;
      
      // Adiciona timestamp para forçar o reload do áudio
      audio.src = `/sounds/${type}.mp3?t=${Date.now()}`;
      
      const playPromise = audio.play();
      
      if (playPromise !== undefined) {
        playPromise
          .then(() => {
            console.log('Audio played successfully:', type);
          })
          .catch((err) => {
            console.log('Audio play failed:', err, 'for type:', type);
            // Tentar tocar novamente após interação do usuário
            document.addEventListener('click', () => {
              audio.play().catch(e => console.log('Retry failed:', e));
            }, { once: true });
          });
      }
    } catch (error) {
      console.error('Error playing alert:', error);
    }
  }, [alertMode, audioSource, playManualAudio]);

  const testSound = useCallback(() => {
    playAlert('novo_pedido');
  }, [playAlert]);

  return (
    <SoundAlertContext.Provider
      value={{
        alertMode,
        audioSource,
        setAlertMode,
        setAudioSource,
        playAlert,
        playManualAudio,
        testSound,
        selectedSounds,
        setSelectedSound,
      }}
    >
      {children}
    </SoundAlertContext.Provider>
  );
}

export function useSoundAlert() {
  const context = useContext(SoundAlertContext);
  if (!context) {
    throw new Error('useSoundAlert must be used within SoundAlertProvider');
  }
  return context;
}
