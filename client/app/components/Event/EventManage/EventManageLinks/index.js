import React, { memo, useContext } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';

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
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Metrics'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Resources'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.metrics.path(groupId, event.id)}
            label='Expenses'
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
