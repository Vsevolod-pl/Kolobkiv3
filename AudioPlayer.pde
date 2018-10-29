import android.media.MediaPlayer;
import android.app.Activity;
import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.PlaybackParams; // if you need to change pitch, for example



class AudioPlayerMy extends MediaPlayer{
  PlaybackParams params;
  AudioPlayerMy(){
    super();
    super.setAudioStreamType(AudioManager.STREAM_MUSIC);
  }
  
  boolean loadFile(String name){
    AssetFileDescriptor afd;
    try{
      afd = getActivity().getAssets().openFd(name);
      super.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
      super.prepare();
    }catch (Exception e) {
      e.printStackTrace();
      return false;
    }
    params = getPlaybackParams();
    return true;
  }
  
  void setPitch(float pitch){
    params.setPitch(pitch);
    setPlaybackParams(params);
  }
  
  void setSpeed(float speed){
    params.setSpeed(speed);
    super.setPlaybackParams(params);
  }
}
