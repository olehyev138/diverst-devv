import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import classNames from 'classnames';
import PropTypes from 'prop-types';

import {
  AppBar, Toolbar, Button, Hidden, Menu, MenuItem, ListItemIcon, IconButton
} from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';

import HomeIcon from '@material-ui/icons/HomeOutlined';
import LightbulbIcon from '@material-ui/icons/WbIncandescentOutlined';
import QuestionAnswerIcon from '@material-ui/icons/QuestionAnswerOutlined';
import EventIcon from '@material-ui/icons/EventOutlined';
import GroupIcon from '@material-ui/icons/GroupOutlined';
import UsersCircleIcon from '@material-ui/icons/GroupWorkOutlined';
import DvrIcon from '@material-ui/core/SvgIcon/SvgIcon';
import ArrowDropDownIcon from '@material-ui/icons/ArrowDropDown';

import { HOME_PATH } from 'containers/Routes/constants';

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
  lightbulbIcon: {
    marginRight: 4,
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  },
  arrowDropDownIcon: {
    '-webkit-transition': 'all 0.20s ease-in-out 0s',
    transition: 'all 0.20s ease-in-out 0s',
  },
  arrowDropDownIconRotated: {
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  },
  paper: {
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: theme.custom.colors.grey,
  },
});

export class UserLinks extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      mobileNavAnchor: null,
    };
  }

  handleMobileNavOpen = (event) => {
    this.setState({ mobileNavAnchor: event.currentTarget });
  };

  handleMobileNavClose = () => {
    this.setState({ mobileNavAnchor: null });
  };

  render() {
    const { mobileNavAnchor } = this.state;
    const { classes, pageTitle } = this.props;
    const isMobileNavOpen = Boolean(mobileNavAnchor);

    // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
    /* eslint-disable-next-line react/no-multi-comp */
    const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

    const MobileNavMenu = () => (
      <Menu
        classes={{
          paper: classes.paper,
        }}
        id='mobileNav'
        disableAutoFocusItem
        anchorEl={mobileNavAnchor}
        getContentAnchorEl={null}
        elevation={0}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        transformOrigin={{ vertical: 'top', horizontal: 'center' }}
        open={isMobileNavOpen}
        onClose={this.handleMobileNavClose}
      >
        <MenuItem component={WrappedNavLink} to={HOME_PATH} activeClassName={classes.mobileNavLinkActive}>
          <ListItemIcon>
            <HomeIcon />
          </ListItemIcon>
          Home
        </MenuItem>
        <MenuItem component={WrappedNavLink} to='/user/campaigns' activeClassName={classes.mobileNavLinkActive}>
          <ListItemIcon>
            <LightbulbIcon className={classes.lightbulbIcon} />
          </ListItemIcon>
          Innovate
        </MenuItem>
        <MenuItem>
          <ListItemIcon>
            <QuestionAnswerIcon />
          </ListItemIcon>
          News
        </MenuItem>
        <MenuItem>
          <ListItemIcon>
            <EventIcon />
          </ListItemIcon>
          Events
        </MenuItem>
        <MenuItem>
          <ListItemIcon>
            <GroupIcon />
          </ListItemIcon>
          Inclusion Networks
        </MenuItem>
        <MenuItem>
          <ListItemIcon>
            <UsersCircleIcon />
          </ListItemIcon>
          Mentorship
        </MenuItem>
      </Menu>
    );

    const NavLinks = () => (
      <Toolbar className={classes.toolbar}>
        <Button component={WrappedNavLink} to={HOME_PATH} className={classes.navLink} activeClassName={classes.navLinkActive}>
          <Hidden smDown>
            <HomeIcon className={classes.navIcon} />
          </Hidden>
          Home
        </Button>
        <Button
          component={WrappedNavLink}
          to='/user/campaigns'
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <LightbulbIcon className={classes.lightbulbIcon} />
          </Hidden>
          Innovate
        </Button>
        <Button
          component={WrappedNavLink}
          to='/user/news'
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <QuestionAnswerIcon className={classes.navIcon} />
          </Hidden>
          News
        </Button>
        <Button
          component={WrappedNavLink}
          to='/user/events'
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <EventIcon className={classes.navIcon} />
          </Hidden>
          Events
        </Button>
        <Button
          component={WrappedNavLink}
          to='/user/groups'
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <GroupIcon className={classes.navIcon} />
          </Hidden>
          Inclusion Networks
        </Button>
        <Button
          component={WrappedNavLink}
          to='/user/groups'
          className={classes.navLink}
          activeClassName={classes.navLinkActive}
        >
          <Hidden smDown>
            <UsersCircleIcon className={classes.navIcon} />
          </Hidden>
          Mentorship
        </Button>
      </Toolbar>
    );

    return (
      <React.Fragment>
        <Hidden smUp>
          <Toolbar className={classes.mobileToolbar}>
            <Button
              className={classes.mobileNavToggleLink}
              aria-controls={
                isMobileNavOpen
                  ? 'mobileNav'
                  : undefined
              }
              aria-haspopup='true'
              onClick={this.handleMobileNavOpen}
            >
              <ArrowDropDownIcon className={classNames(classes.arrowDropDownIcon, isMobileNavOpen ? classes.arrowDropDownIconRotated : null)} />
              {pageTitle}
            </Button>
          </Toolbar>
          <MobileNavMenu />
        </Hidden>
        <Hidden xsDown>
          <NavLinks />
        </Hidden>
      </React.Fragment>
    );
  }
}

UserLinks.propTypes = {
  classes: PropTypes.object,
  pageTitle: PropTypes.string,
};

export function mapDispatchToProps(dispatch) {
  return {
    dispatch
  };
}

const mapStateToProps = createStructuredSelector({});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
  withStyles(styles),
)(UserLinks);
