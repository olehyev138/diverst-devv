import React, { memo } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import classNames from 'classnames';
import PropTypes from 'prop-types';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

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
import CloudDownloadIcon from '@material-ui/icons/CloudDownloadOutlined';
import UsersCircleIcon from '@material-ui/icons/GroupWorkOutlined';
import DvrIcon from '@material-ui/core/SvgIcon/SvgIcon';
import ArrowDropDownIcon from '@material-ui/icons/ArrowDropDown';

import { ROUTES } from 'containers/Shared/Routes/constants';
import messages from 'containers/Session/LoginPage/messages';
import { selectEnterprise, selectPermissions, selectUser } from 'containers/Shared/App/selectors';
import WithPermission from 'components/Compositions/WithPermission';
import dig from 'object-dig';
import { permission } from 'utils/permissionsHelpers';

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
    paddingBottom: 6,
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

const MenuItemPermission = WithPermission(MenuItem);

/* eslint-disable object-curly-newline */
export function MobileNavMenu({ classes, mobileNavAnchor, isMobileNavOpen, handleMobileNavClose, ...props }) {
  return (
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
      onClose={handleMobileNavClose}
    >
      <MenuItem component={WrappedNavLink} exact to={ROUTES.user.home.path()} activeClassName={classes.mobileNavLinkActive}>
        <ListItemIcon>
          <HomeIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.home.data.titleMessage} />
      </MenuItem>
      <MenuItemPermission
        component={WrappedNavLink}
        to={ROUTES.user.innovate.path()}
        activeClassName={classes.mobileNavLinkActive}
        show={dig(props, 'enterprise', 'collaborate_module_enabled')}
      >
        <ListItemIcon>
          <LightbulbIcon className={classes.lightbulbIcon} />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.innovate.data.titleMessage} />
      </MenuItemPermission>
      <MenuItemPermission
        component={WrappedNavLink}
        to={ROUTES.user.news.path()}
        activeClassName={classes.mobileNavLinkActive}
        show={permission(props, 'news_view')}
      >
        <ListItemIcon>
          <QuestionAnswerIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.news.data.titleMessage} />
      </MenuItemPermission>
      <MenuItemPermission
        component={WrappedNavLink}
        to={ROUTES.user.events.path()}
        activeClassName={classes.mobileNavLinkActive}
        show={permission(props, 'events_view')}
      >
        <ListItemIcon>
          <EventIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.events.data.titleMessage} />
      </MenuItemPermission>
      <MenuItemPermission
        component={WrappedNavLink}
        to={ROUTES.user.groups.path()}
        activeClassName={classes.mobileNavLinkActive}
        show={permission(props, 'groups_view')}
      >
        <ListItemIcon>
          <GroupIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.groups.data.titleMessage} />
      </MenuItemPermission>
      <MenuItem component={WrappedNavLink} to={ROUTES.user.downloads.path()} activeClassName={classes.mobileNavLinkActive}>
        <ListItemIcon>
          <CloudDownloadIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.downloads.data.titleMessage} />
      </MenuItem>
      <MenuItemPermission
        component={WrappedNavLink}
        to={ROUTES.user.mentorship.show.path(dig(props, 'user', 'user_id'))}
        activeClassName={classes.mobileNavLinkActive}
        show={dig(props, 'enterprise', 'mentorship_module_enabled')}
      >
        <ListItemIcon>
          <UsersCircleIcon />
        </ListItemIcon>
        <DiverstFormattedMessage {...ROUTES.user.mentorship.data.titleMessage} />
      </MenuItemPermission>
    </Menu>
  );
}

const PermissionButton = WithPermission(Button);

export function NavLinks({ classes, ...props }) {
  return (
    <Toolbar className={classes.toolbar}>
      <Button
        component={WrappedNavLink}
        exact
        to={ROUTES.user.home.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
      >
        <Hidden smDown>
          <HomeIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.home.data.titleMessage} />
      </Button>
      <PermissionButton
        component={WrappedNavLink}
        to={ROUTES.user.innovate.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
        show={dig(props, 'enterprise', 'collaborate_module_enabled')}
      >
        <Hidden smDown>
          <LightbulbIcon className={classes.lightbulbIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.innovate.data.titleMessage} />
      </PermissionButton>
      <PermissionButton
        component={WrappedNavLink}
        to={ROUTES.user.news.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
        show={permission(props, 'news_view')}
      >
        <Hidden smDown>
          <QuestionAnswerIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.news.data.titleMessage} />
      </PermissionButton>
      <PermissionButton
        component={WrappedNavLink}
        to={ROUTES.user.events.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
        show={permission(props, 'events_view')}
      >
        <Hidden smDown>
          <EventIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.events.data.titleMessage} />
      </PermissionButton>
      <PermissionButton
        component={WrappedNavLink}
        to={ROUTES.user.groups.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
        show={permission(props, 'groups_view')}
      >
        <Hidden smDown>
          <GroupIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.groups.data.titleMessage} />
      </PermissionButton>
      <Button
        component={WrappedNavLink}
        to={ROUTES.user.downloads.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
      >
        <Hidden smDown>
          <CloudDownloadIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.downloads.data.titleMessage} />
      </Button>
      <PermissionButton
        component={WrappedNavLink}
        to={ROUTES.user.mentorship.show.path(dig(props, 'user', 'user_id'))}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
        show={dig(props, 'enterprise', 'mentorship_module_enabled')}
      >
        <Hidden smDown>
          <UsersCircleIcon className={classes.navIcon} />
        </Hidden>
        <DiverstFormattedMessage {...ROUTES.user.mentorship.data.titleMessage} />
      </PermissionButton>
    </Toolbar>
  );
}

/* eslint-disable react/no-multi-comp */
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
    const { classes, pageTitle, user } = this.props;
    const isMobileNavOpen = Boolean(mobileNavAnchor);

    // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
    /* eslint-disable-next-line react/no-multi-comp */

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
              <DiverstFormattedMessage {...pageTitle} />
            </Button>
          </Toolbar>
          <MobileNavMenu
            classes={classes}
            mobileNavAnchor={mobileNavAnchor}
            isMobileNavOpen={isMobileNavOpen}
            handleMobileNavClose={this.handleMobileNavClose}
            user={user}
          />
        </Hidden>
        <Hidden xsDown>
          <NavLinks {...this.props} />
        </Hidden>
      </React.Fragment>
    );
  }
}

MobileNavMenu.propTypes = {
  classes: PropTypes.object,
  mobileNavAnchor: PropTypes.object,
  isMobileNavOpen: PropTypes.bool,
  handleMobileNavClose: PropTypes.func,
  user: PropTypes.object,
};

NavLinks.propTypes = {
  classes: PropTypes.object,
  user: PropTypes.object,
};

UserLinks.propTypes = {
  classes: PropTypes.object,
  pageTitle: PropTypes.object,
  user: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
  enterprise: selectEnterprise(),
  permissions: selectPermissions(),
});

const withConnect = connect(
  mapStateToProps,
);

export const StyledUserLinks = withStyles(styles)(UserLinks);

export default compose(
  withConnect,
  withStyles(styles),
  memo,
)(UserLinks);
