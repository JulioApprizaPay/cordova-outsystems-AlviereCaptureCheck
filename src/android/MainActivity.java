import com.alviere.android.alcore.env.EnvironmentOption;
import com.alviere.android.alcore.init.Alviere;
import com.alviere.android.alcore.logging.LogLevelOption;

function public void onCreate(Bundle savedInstanceState)
    if (BuildConfig.DEBUG){
        Alviere.INSTANCE.init(EnvironmentOption.SND, LogLevelOption.VERBOSE);
    }else {
        Alviere.INSTANCE.init(EnvironmentOption.PRD, LogLevelOption.NONE);

    }
end function