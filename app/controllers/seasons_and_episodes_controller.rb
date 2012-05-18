class SeasonsAndEpisodesController < UITableViewController
  CellID = 'SeasonCellIdentifier'
  attr_reader :show

  def initWithShow(show)
    controller = self.init
    controller.seasonsForShow(show)
    controller
  end

  def viewWillAppear(animated)
    true
  end

  def viewDidLoad
    @seasons = []
    Trakt::Show.new(@show.tvdb_id).get_json({}) do |json|
      load_seasons(
        json['seasons'].map { |dict| Season.new(dict) }
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
   @seasons.length
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if @seasons.any?
      @seasons[section].episodes.length
    else
      1
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if @seasons.any?
      season = @seasons[section]
      "Season #{season.number}"
    end
  end

  #def tableView(tableView, heightForRowAtIndexPath:indexPath)
  #  80
  #end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    season = @seasons[indexPath.section]
    episode = season.episodes[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end

    cell.textLabel.text = "#{season.number}X#{episode.number} #{episode.title}"
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    season = @seasons[indexPath.section]
    episode = season.episodes[indexPath.row]
    controller = EpisodeDetailsController.alloc.initWithNibName("EpisodeDetailsController", bundle:nil)
    navigationController.pushViewController(controller, animated:true)
    controller.showDetailsForBroadcast({:show => @show, :episode => episode})
  end

end
