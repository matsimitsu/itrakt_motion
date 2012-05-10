class CalendarController < UITableViewController

  def viewDidLoad
    @calendar = []
    view.dataSource = view.delegate = self
    url = 'http://api.trakt.tv/calendar/shows.json/f05a4d93a7b0838ea46b12a6e86c6cdb'

    Dispatch::Queue.concurrent.async do
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
      unless data
        presentError error_ptr[0]
        return
      end
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
      unless json
        presentError error_ptr[0]
        return
      end

      new_days = []
      json.each do |dict|
        new_days << Day.new(dict)
      end

     Dispatch::Queue.main.sync { load_calendar(new_days) }
    end
    true
  end

  def load_calendar(calendar)
    @calendar = calendar
    view.reloadData
  end

  def presentError(error)
    # TODO
    $stderr.puts error.description
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
    BroadcastCell.heightForBroadcast(@calendar[indexPath.section].broadcasts[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    broadcast = @calendar[indexPath.section].broadcasts[indexPath.row]
    BroadcastCell.cellForBroadcast(broadcast, indexPath:indexPath, inTableView:tableView)
  end

  def reloadRowForBroadcast(broadcast, indexPath)
    view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(indexPath.row, inSection:indexPath.section)], withRowAnimation:false)
  end

end
