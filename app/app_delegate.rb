class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    nav = UINavigationController.alloc.initWithRootViewController(CalendarController.alloc.initWithStyle(UITableViewStylePlain))
    nav.wantsFullScreenLayout = true
    nav.toolbarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    return true
  end
end
