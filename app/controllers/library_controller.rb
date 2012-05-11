class LibraryController < UITableViewController

  def init
    if super
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Library', image:UIImage.imageNamed('library.png'), tag:1)
      self.navigationItem.title = "Library"

    end
    self
  end

  def viewDidLoad
    @library = []
    view.dataSource = view.delegate = self
    Dispatch::Queue.concurrent.async do

      library_request = Trakt::Library.new
      json = library_request.get_json

      if json && json.any?
        new_library = []
        json.each do |dict|
          new_library << Show.new(dict)
        end

       Dispatch::Queue.main.sync { load_library(new_library) }
      end
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
