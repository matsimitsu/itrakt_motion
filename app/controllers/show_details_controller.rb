class ShowDetailsController < UITableViewController
  CellID = 'ShowDetailsCellIdentifier'
  IMAGE_ASPECT_RATIO = 0.679802955665025
  MARGIN = 20
  attr_reader :show

  attr_accessor :bannerCell, :bannerView
  attr_accessor :titleAndSeasonsAndEpisodesCell, :titleLabel, :seasonsAndEpisodesLabel
  attr_accessor :overviewCell, :overviewLabel

  def viewWillAppear(animated)
    true
  end

  def animationDidStop(theAnimation, finished:finished)
    self.bannerView.image = @show.image
  end

  def showDetailsForShow(show)
    @show = show
    self.navigationItem.title = show.title
  end

  def numberOfSectionsInTableView(tableView)
   1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    3
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    case indexPath.row
    when 0
      unless @show.image
        self.bannerView.image = nil
        Dispatch::Queue.concurrent.async do
          image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(@show.image_url))
          if image_data
            @show.image = UIImage.alloc.initWithData(image_data)

            Dispatch::Queue.main.sync do
              self.bannerView.image = @show.image
              xfade = CABasicAnimation.animationWithKeyPath('contents')
              xfade.delegate = self
              xfade.duration = 0.8
              xfade.toValue = @show.image.CGImage
              self.bannerView.layer.addAnimation(xfade, forKey:nil)
            end
          end
        end
      else
        self.bannerView.image = @show.image
      end

      self.bannerCell.bounds.size.height
    when 1
      self.titleAndSeasonsAndEpisodesCell.bounds.size.height
    when 2
      if @show.overview.length > 0
        constrain = CGSize.new(tableView.frame.size.width - (2 * MARGIN), 1000)

        size = @show.overview.sizeWithFont(UIFont.systemFontOfSize(UIFont.systemFontSize), constrainedToSize:constrain)
        return size.height + 12.0;
      end
      20
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.row
    when 0
      return self.bannerCell
    when 1
      self.titleLabel.text = @show.title
      self.seasonsAndEpisodesLabel.text = "Show seasons and episodes"
      return self.titleAndSeasonsAndEpisodesCell
    when 2
      self.overviewLabel.text = @show.overview
      return self.overviewCell
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if indexPath.row == 1
      controller = SeasonsAndEpisodesController.alloc.initWithShow(@show)
      navigationController.pushViewController(controller, animated:true)
    end
  end

end
