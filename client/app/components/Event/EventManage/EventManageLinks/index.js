import React, { memo, useContext } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper, Typography } from '@material-ui/core';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import RouteService from 'utils/routeHelpers';

/* eslint-disable react/no-multi-comp */
export function EventManageLinks(props) {
  const { currentTab, event } = props;

  const rs = new RouteService(useContext);

  const groupId = rs.params('group_id');

  return (
    <React.Fragment>
      <Typography variant='h4' component='h6' align='center' color='primary'>
        <strong>{props.event.name}</strong>
      </Typography>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          {/* NOT IMPLEMENTED YET */}
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Metrics'
            value='metrics'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Fields'
            value='fields'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Updates'
            value='updates'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Resources'
            value='resources'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Expenses'
            value='expenses'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

EventManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.bool,
  ]),
  event: PropTypes.object,
};

export default compose(
  memo,
)(EventManageLinks);
