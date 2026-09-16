abstract final class Routes {
  static const signIn = '/sign-in';

  static const home = channels;

  static const channels = '/channels';

  static const dms = '/dms';

  static const more = '/more';

  static const channelDetailRelative = ':channelId';

  static const moreSettingsRelative = 'settings';

  static const moreSettings = '$more/settings';

  static String channelDetail(String channelId) => '$channels/$channelId';
}
