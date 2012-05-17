class LibraryController < UITableViewController

  def init
    if super
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Library', image:UIImage.imageNamed('library.png'), tag:1)
    end
    self
  end

  def viewDidLoad
    @library = []
    view.dataSource = view.delegate = self
    Trakt::Library.ensuring_json do |json|
      load_library(
        json.map { |dict| Show.new(dict) }
      )
    end
    true
  end

  def load_library(new_library)
    @library = new_library
    view.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @library.length
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    80
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    show = @library[indexPath.row]
    ShowCell.cellForShow(show, indexPath:indexPath, inTableView:tableView)
  end

  def reloadRowForIndexPath(indexPath)
    view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(indexPath.row, inSection:indexPath.section)], withRowAnimation:false)
  end

end
