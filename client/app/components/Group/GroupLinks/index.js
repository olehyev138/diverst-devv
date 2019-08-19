import React, { useContext, memo } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import { withStyles } from '@material-ui/core/styles';
import { FormattedMessage } from 'react-intl';
import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { AppBar, Toolbar, Button, Hidden } from '@material-ui/core';
import { NavLink } from 'react-router-dom';
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

const styles = theme => ({
  toolbar: {
    overflowX: 'auto',
    overflowY: 'hidden',
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
  const { classes } = props;
  const rs = new RouteService(useContext);

  const NavLinks = () => (
    <React.Fragment>
      <Toolbar className={classes.toolbar}>
        <div className={classes.backNavLinkContainer}>
          <Button
            component={WrappedNavLink}
            exact
            to={ROUTES.user.home.path()}
            className={classNames(classes.navLink, classes.backNavLink)}
            activeClassName={classes.navLinkActive}
          >
            <Hidden smDown>
              <BackIcon className={classes.navIcon} />
            </Hidden>
            Back to Dashboard
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
          <FormattedMessage {...ROUTES.group.home.data.titleMessage} />
        </Button>

        <Button
          component={WrappedNavLink}
          exact
          to={ROUTES.group.members.index.path(rs.params('group_id'))}
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <MembersIcon className={classes.navIcon} />
          </Hidden>
          <FormattedMessage {...ROUTES.group.members.index.data.titleMessage} />
        </Button>

        <Button
          component={WrappedNavLink}
          exact
          to={ROUTES.group.events.index.path(rs.params('group_id'))}
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <EventIcon className={classes.navIcon} />
          </Hidden>
          <FormattedMessage {...ROUTES.group.events.index.data.titleMessage} />
        </Button>

        <Button
          className={classes.navLink}
        >
          <Hidden smDown>
            <ResourcesIcon className={classes.navIcon} />
          </Hidden>
          Resources
        </Button>

        <Button
          component={WrappedNavLink}
          exact
          to={ROUTES.group.news.index.path(rs.params('group_id'))}
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <NewsIcon className={classes.navIcon} />
          </Hidden>
          <FormattedMessage {...ROUTES.group.news.index.data.titleMessage} />
        </Button>

        <Button
          component={WrappedNavLink}
          exact
          to={ROUTES.group.outcomes.index.path(rs.params('group_id'))}
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <PlanIcon className={classes.navIcon} />
          </Hidden>
          <FormattedMessage {...ROUTES.group.outcomes.index.data.titleMessage} />
        </Button>

        <Button
          className={classes.navLink}
        >
          <Hidden smDown>
            <ManageIcon className={classes.navIcon} />
          </Hidden>
          Manage
        </Button>
      </Toolbar>
    </React.Fragment>
  );

  return (
    <React.Fragment>
      <NavLinks />
    </React.Fragment>
  );
}

GroupLinks.propTypes = {
  classes: PropTypes.object,
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
