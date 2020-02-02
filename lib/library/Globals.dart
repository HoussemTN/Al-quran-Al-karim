library quran.globals ;

import 'package:shared_preferences/shared_preferences.dart';
/// changes when onChanged Callback
int currentPage  ;
/// contains bookmarkedPage
int bookmarkedPage ;
/// refer to last viewed page (stored in sharedPreferences)
int lastViewedPage;
/// if bookmarkedPage not defined
/// Default Bookmarked page equals to surat Al-baqara index [Default value =569] (Reversed)
int defaultBookmarkedPage=569;


/// @SharedPreferences Const

const LAST_VIEWED_PAGE ='lastViewedPage';

const BOOKMARKED_PAGE ='bookmarkedPage';
