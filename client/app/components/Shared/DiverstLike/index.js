import React, { useState } from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import PaletteIcon from '@material-ui/icons/Palette';
import { IconButton } from '@material-ui/core';
import ThumbUpOutlinedIcon from '@material-ui/icons/ThumbUpOutlined';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import messages from './messages';
import { injectIntl, intlShape } from 'react-intl';

const styles = theme => ({
  liked: {
    color: theme.palette.primary.main,
    paddingRight: 3,
  },
  unliked: {
    color: theme.palette.secondary.main,
    paddingRight: 3,
  },
  itemRemoveButton: {
    color: theme.palette.error.main,
    position: 'absolute',
    right: 3,
    top: 3,
    zIndex: 1,
  },
});

export function DiverstLike(props) {
  const { isLiked: defaultLiked, totalLikes: defaultCount, classes } = props;

  const [liked, setLiked] = useState(defaultLiked);
  const [count, setCount] = useState(defaultCount);

  function like() {
    setLiked(true);
    setCount(defaultLiked ? defaultCount : defaultCount + 1);
  }
  function unlike() {
    setLiked(false);
    setCount(defaultLiked ? defaultCount - 1 : defaultCount);
  }

  return (
    <React.Fragment>
      <IconButton
        aria-label={props.intl.formatMessage(messages.color, props.customTexts)}
        size='small'
        onClick={() => {
          if (liked)
            props.unlikeNewsItemBegin({ news_feed_link_id: props.newsFeedLinkId, callback: unlike });
          else
            props.likeNewsItemBegin({ news_feed_link_id: props.newsFeedLinkId, callback: like });
        }}
      >
        {liked
          ? <ThumbUpIcon className={classes.liked} />
          : <ThumbUpOutlinedIcon className={classes.unliked} />}
        {count}
      </IconButton>
    </React.Fragment>
  );
}

DiverstLike.propTypes = {
  classes: PropTypes.object,
  totalLikes: PropTypes.number,
  isLiked: PropTypes.bool,
  newsFeedLinkId: PropTypes.number,
  answerId: PropTypes.number,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  customTexts: PropTypes.object,
  intl: intlShape.isRequired
};

export default compose(
  injectIntl,
  withStyles(styles),
)(DiverstLike);
