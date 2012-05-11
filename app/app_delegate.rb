class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    tabbar = UITabBarController.alloc.init
    tabbar.viewControllers = [
      CalendarController.alloc.init,
      LibraryController.alloc.init
    ]
    tabbar.selectedIndex = 0

    UINavigationController.alloc.initWithRootViewController(tabbar)
    navbar = UINavigationController.alloc.initWithRootViewController(tabbar)
    navbar.wantsFullScreenLayout = true
    navbar.toolbarHidden = true
    navbar.title = "Calendar"
    @window.rootViewController = navbar
    @window.makeKeyAndVisible
    return true
  end
end
