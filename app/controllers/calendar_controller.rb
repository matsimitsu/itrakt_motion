class CalendarController < UITableViewController

  def init
    if super
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('Calendar', image:UIImage.imageNamed('calendar.png'), tag:1)
    end
    self
  end

  def viewDidLoad
    @calendar = []
    view.dataSource = view.delegate = self
    Trakt::Calendar.ensuring_json do |json|
      load_calendar(
        json.map { |dict| BroadcastDay.new(dict) }
      )
    end
    true
  end

  def load_calendar(calendar)
    @calendar = calendar
    view.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    @calendar.length
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if @calendar.any?
      section = @calendar[section]
      section.date
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if @calendar.any?
      @calendar[section].broadcasts.length
    else
      0
    end
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    80
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    broadcast = @calendar[indexPath.section].broadcasts[indexPath.row]
    BroadcastCell.cellForBroadcast(broadcast, indexPath:indexPath, inTableView:tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    broadcast = @calendar[indexPath.section].broadcasts[indexPath.row]
    controller = EpisodeDetailsController.alloc.initWithNibName("EpisodeDetailsController", bundle:nil)
    navigationController.pushViewController(controller, animated:true)
    controller.showDetailsForBroadcast(broadcast)
  end

  def reloadRowForIndexPath(indexPath)
    view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(indexPath.row, inSection:indexPath.section)], withRowAnimation:false)
  end

end
