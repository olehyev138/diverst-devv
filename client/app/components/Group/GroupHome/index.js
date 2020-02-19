/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Divider, Grid, Typography } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';
import EventsPage from 'containers/Event/EventsPage';
import NewsPage from 'containers/News/NewsFeedPage';

export function GroupHome(props) {
  return (
    <React.Fragment>
      <Grid container spacing={3}>
        {props.currentGroup.banner_data && (
          <DiverstImg
            data={props.currentGroup.banner_data}
            alt=''
            maxWidth='100%'
            minWidth='100%'
          />
        )}
        <Grid item xs>
          <EventsPage
            currentGroup={props.currentGroup}
            readonly
            loaderProps={{
              transitionProps: {
                direction: 'right',
              },
            }}
          />
        </Grid>
        <Grid item xs='auto'>
          <Divider orientation='vertical' />
        </Grid>
        <Grid item xs>
          <NewsPage
            currentGroup={props.currentGroup}
            readonly
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupHome.propTypes = {
  currentGroup: PropTypes.object,
};

export default compose(
  memo,
)(GroupHome);
