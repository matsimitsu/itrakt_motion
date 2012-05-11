class EpisodeDetailsController < UITableViewController
  CellID = 'EpisodeDetailsCellIdentifier'
  IMAGE_ASPECT_RATIO = 0.679802955665025
  MARGIN = 20
  attr_reader :episode, :show

  attr_accessor :bannerCell, :bannerView
  attr_accessor :titleAndEpisodeAndSeasonCell, :seenCheckbox, :titleLabel, :episodeAndSeasonLabel
  attr_accessor :overviewCell, :overviewLabel
  attr_accessor :showDetailsCell, :showTitleLabel

  def viewWillAppear(animated)
    true
  end
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def showDetailsForBroadcast(broadcast)
    @episode = broadcast[:episode]
    @show = broadcast[:show]
    self.navigationItem.title = show.title
  end

  def numberOfSectionsInTableView(tableView)
   1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @episode.overview ? 4 : 3
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    case indexPath.row
    when 0
      (tableView.frame.size.width * IMAGE_ASPECT_RATIO).floor
    when 1
      40
    when 2
      if @episode.overview.length > 0
        constrain = CGSize.new(tableView.frame.size.width - (2 * MARGIN), 1000)

        size = @episode.overview.sizeWithFont(UIFont.systemFontOfSize(UIFont.smallSystemFontSize), constrainedToSize:constrain)
        return size.height + 12.0;
      end
      20
    when 3
      40
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    cell.opaque = true
    case indexPath.row
    when 0

      unless episode.image
        cell.imageView.image = nil
        Dispatch::Queue.concurrent.async do
          image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(episode.image_url))
          if image_data
            episode.image = UIImage.alloc.initWithData(image_data)

            Dispatch::Queue.main.sync do
              cell.imageView.image = episode.image
              cell.imageView.opaque = true;
              cell.imageView.layer.masksToBounds = true;

              tableView.delegate.reloadRowForImage
            end
          end
        end
      else
        cell.imageView.image = episode.image
      end
    when 1
      cell.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize)
      cell.textLabel.text = "#{@episode.season_and_episode_number} #{@show.title}"
    when 2
      cell.textLabel.numberOfLines = 0
      cell.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize)
      cell.textLabel.lineBreakMode = UILineBreakModeWordWrap
      cell.textLabel.lineBreakMode = UILineBreakModeWordWrap
      if @episode.overview.length > 0
        cell.textLabel.text = @episode.overview
      else
        cell.textLabel.textColor = UIColor.grayColor
        cell.textLabel.text = "No description available"
      end
    when 3
      cell.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize)
      cell.textLabel.text = "#{@show.air_time} on #{@show.network}"
    end
    cell
  end

  def reloadRowForImage
    view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(0, inSection:0)], withRowAnimation:false)
  end

end
