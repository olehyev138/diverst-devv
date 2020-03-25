import React, { useContext, memo } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import dig from 'object-dig';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import classNames from 'classnames';
import { matchPath } from 'react-router';

import { useLastLocation } from 'react-router-last-location';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Toolbar, Button, Hidden } from '@material-ui/core';
import PropTypes from 'prop-types';

import BackIcon from '@material-ui/icons/KeyboardBackspaceOutlined';
import HomeIcon from '@material-ui/icons/HomeOutlined';
import MembersIcon from '@material-ui/icons/PeopleOutline';
import EventIcon from '@material-ui/icons/EventOutlined';
import ResourcesIcon from '@material-ui/icons/FolderSharedOutlined';
import NewsIcon from '@material-ui/icons/QuestionAnswerOutlined';
import ManageIcon from '@material-ui/icons/SettingsOutlined';
import PlanIcon from '@material-ui/icons/AssignmentTurnedInOutlined';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import PerfectScrollbar from 'react-perfect-scrollbar';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  toolbar: {
    overflowX: 'visible',
    overflowY: 'hidden',
    minWidth: 'max-content',
    whiteSpace: 'nowrap',
    display: 'block',
    backgroundColor: 'white',
    textAlign: 'center',
    minHeight: 'unset',
    maxHeight: 64,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomColor: theme.custom.colors.lightGrey,
    paddingTop: 12,
    paddingBottom: 0,
  },
  mobileToolbar: {
    display: 'block',
    backgroundColor: 'white',
    textAlign: 'center',
    minHeight: 'unset',
    maxHeight: 64,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomColor: theme.custom.colors.lightGrey,
  },
  navLinkActive: {
    color: theme.palette.primary.main,
    borderBottomColor: theme.palette.primary.main,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomLeftRadius: 0,
    borderBottomRightRadius: 0,
    marginBottom: '0 !important',
    paddingBottom: '7px !important', // To account for the border size
  },
  navLink: {
    textAlign: 'center',
    fontSize: '0.9rem',
    fontWeight: 500,
    paddingTop: 4,
    paddingBottom: 4,
    paddingLeft: 8,
    paddingRight: 8,
    marginLeft: 6,
    marginRight: 6,
    marginBottom: 4,
  },
  navIcon: {
    marginRight: 4,
  },
  mobileNavToggleLink: {
    textAlign: 'center',
    fontSize: '1.1rem',
    textTransform: 'none',
    fontWeight: 500,
  },
  mobileNavLinkActive: {
    backgroundColor: 'rgba(0, 0, 0, 0.14)',
  },
  arrowDropDownIcon: {
    '-webkit-transition': 'all 0.20s ease-in-out 0s',
    transition: 'all 0.20s ease-in-out 0s',
  },
  arrowDropDownIconRotated: {
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  },
  backNavLinkContainer: {
    marginBottom: -4,
    [theme.breakpoints.up('lg')]: {
      position: 'absolute',
      left: 0,
    },
    [theme.breakpoints.down('md')]: {
      float: 'left',
      borderRight: '1px solid #999999',
      borderRadius: 0,
      paddingRight: 4,
    },
  },
  backNavLink: {
    marginBottom: 0,
  },
});

export function GroupLinks(props) {
  const { classes, currentGroup } = props;
  const rs = new RouteService(useContext);

  const lastLocation = useLastLocation();
  let lastPageWasGroupLayout = true;

  if (lastLocation)
    lastPageWasGroupLayout = !!matchPath(lastLocation.pathname, {
      path: ROUTES.group.home.path(),
      exact: false,
      strict: false,
    });

  const NavLinks = () => (
    <div>
      <PerfectScrollbar
        options={{
          suppressScrollY: true,
          useBothWheelAxes: true,
          swipeEasing: true,
        }}
      >
        <Toolbar className={classes.toolbar}>
          <div className={classes.backNavLinkContainer}>
            <Button
              component={WrappedNavLink}
              exact
              to={lastPageWasGroupLayout ? ROUTES.user.home.path() : lastLocation}
              className={classNames(classes.navLink, classes.backNavLink)}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <BackIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.back.data.titleMessage} />
            </Button>
          </div>

          <Button
            component={WrappedNavLink}
            exact
            to={ROUTES.group.home.path(rs.params('group_id'))}
            className={classes.navLink}
            activeClassName={classes.navLinkActive}
          >
            <Hidden smDown>
              <HomeIcon className={classes.navIcon} />
            </Hidden>
            <DiverstFormattedMessage {...ROUTES.group.home.data.titleMessage} />
          </Button>

          <Permission show={permission(props.currentGroup, 'members_view?')}>
            <Button
              component={WrappedNavLink}
              to={ROUTES.group.members.index.path(rs.params('group_id'))}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <MembersIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.members.index.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentGroup, 'events_view?')}>
            <Button
              component={WrappedNavLink}
              to={ROUTES.group.events.index.path(rs.params('group_id'))}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <EventIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.events.index.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentGroup, 'resources_view?')}>
            <Button
              component={WrappedNavLink}
              exact
              to={ROUTES.group.resources.index.path(rs.params('group_id'))}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <ResourcesIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.resources.index.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentGroup, 'news_view?')}>
            <Button
              component={WrappedNavLink}
              to={ROUTES.group.news.index.path(rs.params('group_id'))}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <NewsIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.news.index.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentGroup, 'kpi_manage?') || permission(props.currentGroup, 'events_manage?') || permission(props.currentGroup, 'budgets_view?')}>
            <Button
              component={WrappedNavLink}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
              to={ROUTES.group.plan.events.index.path(rs.params('group_id'))}
              isActive={(match, location) => !!matchPath(location.pathname, {
                path: ROUTES.group.plan.index.data.pathPrefix(rs.params('group_id')),
                exact: false,
                strict: false,
              })}
            >
              <Hidden smDown>
                <PlanIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.plan.index.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentGroup, 'update?')}>
            <Button
              component={WrappedNavLink}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
              to={ROUTES.group.manage.settings.index.path(rs.params('group_id'))}
              isActive={(match, location) => !!matchPath(location.pathname, {
                path: ROUTES.group.manage.index.data.pathPrefix(rs.params('group_id')),
                exact: false,
                strict: false,
              })}
            >
              <Hidden smDown>
                <ManageIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.group.manage.index.data.titleMessage} />
            </Button>
          </Permission>
        </Toolbar>
      </PerfectScrollbar>
    </div>
  );

  return (
    <React.Fragment>
      <NavLinks />
    </React.Fragment>
  );
}

GroupLinks.propTypes = {
  classes: PropTypes.object,
  currentGroup: PropTypes.shape({
    permissions: PropTypes.object
  }),
  computedMatch: PropTypes.shape({
    params: PropTypes.shape({
      id: PropTypes.string
    })
  }),
};

export default compose(
  withStyles(styles),
  memo,
)(GroupLinks);
