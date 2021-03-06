class AppDelegate

  attr_accessor :navigationController, :tabBarController

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    user_cache['username'] = nil
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    tabBarController.selectedIndex = 0
    tabBarController.viewControllers = [
      CalendarController.alloc.init,
      LibraryController.alloc.init
    ]

    navigationController.toolbarHidden = true
    @window.rootViewController = self.navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    unless user_cache['username']
      auth = AuthenticationViewController.alloc.initWithNibName(
        "AuthenticationViewController",
        bundle:nil
      )
      @window.rootViewController.presentModalViewController(auth, animated:true)
    end
    return true
  end

  def navigationController
    @navigationController ||= UINavigationController.alloc.initWithRootViewController(tabBarController )
  end

  def tabBarController
    @tabBarController ||= UITabBarController.alloc.init
  end

end
