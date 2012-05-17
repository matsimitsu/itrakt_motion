class SplashController < UIViewController

  def viewWillAppear(animated)
    #navigationController.setNavigationBarHidden(true, animated:animated)
    checkAuth
  end

end
