import com.alviere.android.alcore.env.EnvironmentOption;
import com.alviere.android.alcore.init.Alviere;
import com.alviere.android.alcore.logging.LogLevelOption;
import com.luisbouca.test.BuildConfig;

function public void onCreate(Bundle savedInstanceState)
    if (BuildConfig.DEBUG){
        Alviere.INSTANCE.init(cordova.getActivity(), EnvironmentOption.SND, LogLevelOption.VERBOSE);
    }else {
        Alviere.INSTANCE.init(cordova.getActivity(), EnvironmentOption.PRD, LogLevelOption.NONE);

    }
end function