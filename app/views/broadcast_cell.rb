class BroadcastCell < UITableViewCell
  attr_accessor :index_path, :series_title_and_episode_number, :episode_title, :airtime_and_channel

  CellID = 'CellIdentifier'

  POSTER_ASPECT_RATIO = 0.679802955665025
  MARGIN = 8.0
  MARGIN_UNDERNEATH_LABEL = 4.0


  def self.cellForBroadcast(broadcast, indexPath:indexPath, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(BroadcastCell::CellID) || BroadcastCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.index_path = indexPath
    cell.fillWithBroadcast(broadcast, inTableView:tableView)
    cell
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.series_title_and_episode_number = UILabel.new
      self.series_title_and_episode_number.opaque = true
      self.series_title_and_episode_number.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize)
      self.contentView.addSubview series_title_and_episode_number

      self.episode_title = UILabel.new
      self.episode_title.opaque = true
      self.episode_title.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize)
      self.contentView.addSubview episode_title

      self.airtime_and_channel = UILabel.new
      self.airtime_and_channel.opaque = true
      self.airtime_and_channel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize)
      self.contentView.addSubview airtime_and_channel
    end
    self
  end

  def fillWithBroadcast(broadcast, inTableView:tableView)
    show, episode = broadcast[:show], broadcast[:episode]

    self.series_title_and_episode_number.text = "#{episode.season_and_episode_number} #{show.title}"
    self.episode_title.text = episode.title
    self.airtime_and_channel.text = "#{show.air_time} on #{show.network}"

    unless show.poster
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(show.poster_url))
        if image_data
          show.poster = UIImage.alloc.initWithData(image_data)

          Dispatch::Queue.main.sync do
            self.imageView.image = show.poster
            self.imageView.opaque = true;
            self.imageView.layer.masksToBounds = true;
            self.imageView.layer.cornerRadius = 2.0;
            #self.imageView.layer.minificationFilter = kCAFilterTrilinear;

            tableView.delegate.reloadRowForIndexPath(index_path)
          end
        end
      end
    else
      self.imageView.image = show.poster
    end
  end

  def layoutSubviews
    super

    # Set colors depending on selected state
    if self.selected?
      self.series_title_and_episode_number.textColor = UIColor.whiteColor
      self.episode_title.textColor = UIColor.whiteColor
      self.airtime_and_channel.textColor = UIColor.whiteColor
    else
      self.series_title_and_episode_number.textColor = UIColor.blackColor
      self.episode_title.textColor = UIColor.grayColor
      self.airtime_and_channel.textColor = UIColor.grayColor
    end

    # Setup some base vars
    size = self.bounds.size
    x = 0
    y = 0
    imageWidth, labelWidth, labelHeight = 0

    # Poster
    imageWidth = (size.height * POSTER_ASPECT_RATIO).floor
    imageSize = CGSizeMake(imageWidth, size.height)
    self.imageView.frame = CGRectMake(x, y, imageSize.width, imageSize.height)

    # Show title and episode number
    x += imageWidth + MARGIN
    y += MARGIN
    labelWidth = size.width - x
    labelHeight = UIFont.systemFontSize + MARGIN_UNDERNEATH_LABEL
    self.series_title_and_episode_number.frame = CGRectMake(x, y, labelWidth, labelHeight)

    # Epsiode title
    y += labelHeight + MARGIN_UNDERNEATH_LABEL
    labelHeight = UIFont.smallSystemFontSize + MARGIN_UNDERNEATH_LABEL
    self.episode_title.frame = CGRectMake(x, y, labelWidth, labelHeight)

    # Airtime and channel
    y += labelHeight + MARGIN_UNDERNEATH_LABEL
    self.airtime_and_channel.frame = CGRectMake(x, y, labelWidth, labelHeight)
  end

end
