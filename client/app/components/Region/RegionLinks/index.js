import React, { memo } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import classNames from 'classnames';
import { matchPath } from 'react-router-dom';

import { useLastLocation } from 'react-router-last-location';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Toolbar, Button, Hidden } from '@material-ui/core';
import PropTypes from 'prop-types';

import BackIcon from '@material-ui/icons/KeyboardBackspaceOutlined';
import HomeIcon from '@material-ui/icons/HomeOutlined';
import MembersIcon from '@material-ui/icons/PeopleOutline';
import LeadersIcon from '@material-ui/icons/EmojiPeople';

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

export function RegionLinks(props) {
  const { classes, currentRegion } = props;

  const lastLocation = useLastLocation();
  let lastPageWasRegionLayout = true;

  if (lastLocation)
    lastPageWasRegionLayout = !!matchPath(lastLocation.pathname, {
      path: ROUTES.region.home.path(),
      exact: false,
      strict: false,
    });

  return (
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
              to={lastPageWasRegionLayout ? ROUTES.user.home.path() : lastLocation}
              className={classNames(classes.navLink, classes.backNavLink)}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <BackIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.region.back.data.titleMessage} />
            </Button>
          </div>

          <Button
            component={WrappedNavLink}
            exact
            to={ROUTES.region.home.path(currentRegion.id)}
            className={classes.navLink}
            activeClassName={classes.navLinkActive}
          >
            <Hidden smDown>
              <HomeIcon className={classes.navIcon} />
            </Hidden>
            <DiverstFormattedMessage {...ROUTES.region.home.data.titleMessage} />
          </Button>

          <Permission show={permission(props.currentRegion, 'members_view?')}>
            <Button
              component={WrappedNavLink}
              to={ROUTES.region.members.path(currentRegion.id)}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <MembersIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.region.members.data.titleMessage} />
            </Button>
          </Permission>

          <Permission show={permission(props.currentRegion, 'leaders_view?')}>
            <Button
              component={WrappedNavLink}
              to={ROUTES.region.leaders.index.path(currentRegion.id)}
              className={classes.navLink}
              activeClassName={classes.navLinkActive}
            >
              <Hidden smDown>
                <LeadersIcon className={classes.navIcon} />
              </Hidden>
              <DiverstFormattedMessage {...ROUTES.region.leaders.index.data.titleMessage} />
            </Button>
          </Permission>
        </Toolbar>
      </PerfectScrollbar>
    </div>
  );
}

RegionLinks.propTypes = {
  classes: PropTypes.object,
  currentRegion: PropTypes.shape({
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
)(RegionLinks);