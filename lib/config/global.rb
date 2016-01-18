module NUSBotgram
  class Global
    # Constant
    BOT_NAME = 'Venus'
    START_YEAR = 2015
    END_YEAR = 2016
    SEM = 2
    X_MINUTES = 5
    X_MINUTES_BUFFER = 15
    DAY_REGEX = /([a-zA-Z]{6,})/

    # Bot commands
    SETMODURL = '/setmodurl'
    LISTMODS = '/listmods'
    GETMOD = '/getmod'
    TODAYME = '/todayme'
    TODAYSTAR = '/today*'

    # Bot Actions
    SEND_MESSAGE = '/sendMessage'

    # Lesson Types
    DESIGN_LECTURE = 'Design Lecture'
    LABORATORY = 'Laboratory'
    LECTURE = 'Lecture'
    PACKAGED_LECTURE = 'Packaged Lecture'
    PACKAGED_TUTORIAL = 'Packaged Tutorial'
    RECITATION = 'Recitation'
    SECTIONAL_TEACHING = 'Sectional Teaching'
    SEMINAR_STYLE_MODULE_CLASS = 'Seminar-Style Module Class'
    TUTORIAL = 'Tutorial'
    TUTORIAL_TYPE_2 = 'Tutorial Type 2'
    TUTORIAL_TYPE_3 = 'Tutorial Type 3'

    # Bot's Service Messages
    BOT_TUTORIAL_MESSAGE = "Hello there, I am #{BOT_NAME}. Thank you for using NUSBot Service!\nAsk me anything around NUS! I am your guide. I manage your timetable. I am your personal butler."
    BOT_TUTORIAL_MESSAGE_2 = "Let's get started! I would like to show you around.\nI am not very advanced yet to process complex queries, but I can manage simple queries for now."
    BOT_TUTORIAL_MESSAGE_3 = "Start exploring by sending /help for more usage.\nYou can control me by sending these commands:\n\n/setmodurl - sets your nusmods url\n/listmods - list your modules\n/getmod - get a particular module\n/today - get your schedule for today\n/todayme - guide to get today's schedule\n/tomorrow - get your schedule for tomorrow\n/nextclass - get your next class schedule\n/cancel - cancel the current operation"
    BOT_TOUR_MESSAGE = "Hello there, thank you for using NUSBot Service!\nAsk me anything around NUS! I am your guide. I manage your timetable. I am your personal butler.\n\nI noticed that you are new here and I would like to show you around.\nI am not very advanced yet to process complex queries, but I can manage simple queries for now.\n\nStart exploring by sending /help for more usage.\nYou can control me by sending these commands:\n\n/setmodurl - sets your nusmods url\n/listmods - list your modules\n/getmod - get a particular module\n/today - get your schedule for today\n/todayme - guide to get today's schedule\n/tomorrow - get your schedule for tomorrow\n/nextclass - get your next class schedule\n/cancel - cancel the current operation"
    BOT_MAINTENANCE_MESSAGE = "Hello there, thank you for using NUSBot Service!\nI will be undergoing a scheduled maintenance today from <00:00 - 01:30> (GMT+08:00).\n\nPlease be advised that the bot service may experience some downtime during that scheduled period.\n\nUpdates:\n1. I will have a new alert system with persistent storage.\n2. Minor updates on my brain."
    BOT_SERVICE_OFFLINE = "Bump! I think that Telegram's service is temporary unavailable..."
    BOT_SETMODURL_CANCEL = "The command 'setmodurl' has been cancelled. Anything else I can do for you?"
    BOT_GETMOD_CANCEL = "The command 'getmod' has been cancelled. Anything else I can do for you?"
    BOT_TODAYME_CANCEL = "The command 'todayme' has been cancelled. Anything else I can do for you?"
    BOT_CANCEL_MESSAGE = "Alright! I will not process this for now!\nBut if you change your mind, just let me know again!\n\nSend /help for a list of commands"
    BOT_CANCEL_NO_STATE = "No active command to cancel. I wasn't doing anything anyway. Zzzzz..."
    BOT_ALERT_MESSAGE = "Use this format to create alerts:\n/alert duration task\n\n'Duration' can be one of the following:\n- The number of minutes, hours, days or weeks until the alert in the form 30m, 6h, 20d or 15w, 3M, 1y respectively.\n\n'Task' is anything you want the bot to tell you."

    # Venus Bot's reply messages
    SEND_NUSMODS_URI_MESSAGE = "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)"
    REGISTERED_NUSMODS_URI_MESSAGE = "Awesome! I have registered your NUSMods URL"
    INVALID_NUSMODS_URI_MESSAGE = "I'm afraid this is an invalid NUSMODS URL that I do not recognize."
    NUSMODS_URI_CANCEL_MESSAGE = "I am cancelling this operation because I do not understand what to process."
    NUSMODS_URI_RETRY_MESSAGE = "Please try again to '/setmodurl' with a correct NUSMods URL."
    RETRIEVE_TIMETABLE_MESSAGE = "Give me awhile, while I retrieve your timetable..."
    NEXT_CLASS_MESSAGE = "Your next class schedule is..."
    NEXT_CLASS_NULL_MESSAGE = "That's awesome! Well, I guess that's the end of the day for you today!"
    DISPLAY_MODULE_MESSAGE = "Alright! What module do you want me to display?"
    SEARCH_MODULES_MESSAGE = "Alright! What modules do you want to search?"
    GET_TIMETABLE_TODAY_MESSAGE = "Alright! Let's get you your schedule for today!"
    GET_TIMETABLE_TOMORROW_MESSAGE = "Alright! Let's get you your schedule for tomorrow!"
    NSATURDAY_RESPONSE = "One does not simply have classes on Saturday!"
    NSUNDAY_RESPONSE = "You've got to be kidding! It's Sunday, you shouldn't have any classes today!"
    NSUNDAY_RESPONSE_END = "C'mon, have a break, will ya!"
    FREEDAY_RESPONSE = "Yay! It's YOUR free day! Hang around and chill with me!"
    UNRECOGNIZED_LOCATION_RESPONSE = "Say what? I don't think I understand where that is. Anything else I can do for you?"

    # Action types
    TYPING_ACTION = "typing"
    UPLOAD_PHOTO_ACTION = "upload_photo"
    RECORD_VIDEO_ACTION = "record_video"
    UPLOAD_VIDEO_ACTION = "upload_video"
    RECORD_AUDIO_ACTION = "record_audio"
    UPLOAD_AUDIO_ACTION = "upload_audio"
    UPLOAD_DOCUMENT_ACTION = "upload_document"
    FIND_LOCATION_ACTION = "find_location"
    UNRECOGNIZED_COMMAND_RESPONSE = "Unrecognized command. Say what?"
    CUSTOM_TODAY_KEYBOARD = [%w(Today), %w(DLEC), %w(LAB), %w(LEC), %w(PLEC), %w(PTUT), %w(REC), %w(SEC), %w(SEM), %w(TUT), %w(TUT2), %w(TUT3)]

    # Transaction State
    NOT_READY = 0
    SENT = 1
    IN_TRANSIT = 2
    ERR = 3
    INACTIVE = 4
  end
end