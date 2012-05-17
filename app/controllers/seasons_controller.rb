class SeasonsController < UITableViewController
  CellID = 'SeasonCellIdentifier'
  attr_reader :show

  def viewWillAppear(animated)
    true
  end

  def viewDidLoad
    @seasons = []
    Trakt::Seasons.new(@show.tvdbid).get_json do |json|
      load_seasons(
        json.map { |dict| Season.new(dict) }
      )
    end
  end

  def load_seasons(seasons)
    @seasons = seasons
    view.reloadData
  end

  def seasonsForShow(show)
    @show = show
    self.navigationItem.title = show.title
  end

  def numberOfSectionsInTableView(tableView)
   1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @seasons.length
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    80
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    season = @seasons[indexPath.row]

    unless cell
      cell = tableView.dequeueReusableCellWithIdentifier(EpisodeDetailsController::CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      cell.index_path = indexPath
    end

    cell.textLabel.text = "Season #{season.number}"
  end
end
