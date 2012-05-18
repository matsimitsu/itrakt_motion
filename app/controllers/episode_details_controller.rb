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

  def animationDidStop(theAnimation, finished:finished)
    self.bannerView.image = @episode.image
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
      unless @episode.image
        self.bannerView.image = nil
        Dispatch::Queue.concurrent.async do
          image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(@episode.image_url))
          if image_data
            @episode.image = UIImage.alloc.initWithData(image_data)

            Dispatch::Queue.main.sync do
              self.bannerView.image = @episode.image
              xfade = CABasicAnimation.animationWithKeyPath('contents')
              xfade.delegate = self
              xfade.duration = 0.8
              xfade.toValue = @episode.image.CGImage
              self.bannerView.layer.addAnimation(xfade, forKey:nil)
            end
          end
        end
      else
        self.bannerView.image = @episode.image
      end
      self.bannerCell.bounds.size.height
    when 1
      self.titleAndEpisodeAndSeasonCell.bounds.size.height
    when 2
      if @episode.overview.length > 0
        constrain = CGSize.new(tableView.frame.size.width - (2 * MARGIN), 1000)

        size = @episode.overview.sizeWithFont(UIFont.systemFontOfSize(UIFont.systemFontSize), constrainedToSize:constrain)
        return size.height + 12.0;
      end
      20
    when 3
      self.showDetailsCell.bounds.size.height
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.row
    when 0
      return self.bannerCell
    when 1
      self.seenCheckbox.setSelected(false, withAnimation:false)
      self.titleLabel.text = @episode.title
      self.episodeAndSeasonLabel.text = "#{@episode.season}x#{@episode.number} - Aired on #{@show.network}"
      return self.titleAndEpisodeAndSeasonCell
    when 2
      self.overviewLabel.text = @episode.overview
      return self.overviewCell
    when 3
      self.showTitleLabel.text = @show.title
      return self.showDetailsCell
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if indexPath.row == 3
      controller = ShowDetailsController.alloc.initWithNibName("ShowDetailsViewController", bundle:nil)
      navigationController.pushViewController(controller, animated:true)
      controller.showDetailsForShow(@show)
    end
  end

end
