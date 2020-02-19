import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import GroupHome from 'components/Group/GroupHome';
import { Divider, Grid } from '@material-ui/core';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

// TODO : Change EventsPage
import EventsPage from '../../User/UserEventsPage';
import NewsPage from '../GroupNewsFeedPage';

export function GroupHomePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item xs>
          <EventsPage
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
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupHomePage.propTypes = {
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupHomePage);
