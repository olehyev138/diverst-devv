import React, { memo } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { createStructuredSelector } from 'reselect';
import classNames from 'classnames';

import { withStyles } from '@material-ui/core/styles';
import {
  AppBar, Box, Button, Hidden, IconButton, Link, ListItemIcon, Menu, MenuItem, Toolbar, Typography, CardActionArea
} from '@material-ui/core';
import AccountCircleIcon from '@material-ui/icons/AccountCircle';
import PermIdentityIcon from '@material-ui/icons/PermIdentity';
import ExitToAppIcon from '@material-ui/icons/ExitToApp';
import BuildIcon from '@material-ui/icons/Build';
import DvrIcon from '@material-ui/icons/Dvr';
import MenuIcon from '@material-ui/icons/Menu';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import Logo from 'components/Shared/Logo/index';
import { logoutBegin } from 'containers/Shared/App/actions';

import { selectEnterprise, selectUser, selectPermissions } from 'containers/Shared/App/selectors';

import { selectGroup } from 'containers/Group/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/App/messages';
import { resolveRootManagePath } from 'utils/adminLinkHelpers';
import Permission from 'components/Shared/DiverstPermission';

const styles = theme => ({
  grow: {
    flexGrow: 1,
  },
  centerText: {
    textAlign: 'center',
  },
  sectionDesktop: {
    display: 'flex',
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  toolbar: theme.mixins.toolbar,
  paper: {
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: theme.custom.colors.grey,
  },
  buttonSection: {
    display: 'flex',
    alignItems: 'center',
  },
  dashboardSwitchButton: {
    color: '#FFFFFF',
    borderColor: '#FFFFFF',
    height: '40px',
    padding: '0px 8px',
    marginRight: '8px',
  },
  dashboardSwitchMenuItem: {
    [theme.breakpoints.up('sm')]: {
      display: 'none',
    },
  },
  dashboardIcon: {
    marginRight: 4,
    fontSize: 20,
  },
  adminIcon: {
    marginRight: 2,
    fontSize: 18,
  },
  drawerToggle: {
    marginRight: theme.spacing(2),
    [theme.breakpoints.up('md')]: {
      display: 'none',
    },
  },
  navLinkActive: {
    backgroundColor: 'rgba(0, 0, 0, 0.14)',
  },
  whiteButton: {
    color: '#ffffff',
  }
});

export class ApplicationHeader extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      drawerOpen: props.drawerOpen,
      menuAnchor: null,
    };

    this.logoutBegin = this.logoutBegin.bind(this);
  }

  logoutBegin() {
    this.props.logoutBegin();
  }

  handleProfileMenuOpen = (event) => {
    this.setState({ menuAnchor: event.currentTarget });
  };

  handleProfileMenuClose = () => {
    this.setState({ menuAnchor: null });
  };

  handleDrawerToggle = () => {
    this.setState(
      state => ({ drawerOpen: !state.drawerOpen }),
      () => (this.props.drawerToggleCallback(this.state.drawerOpen))
    );
  };

  render() {
    const { menuAnchor } = this.state;
    const {
      classes, enterprise, group, position, isAdmin, user, permissions
    } = this.props;
    const isMenuOpen = Boolean(menuAnchor);

    const adminPath = resolveRootManagePath(permissions);

    const renderMenu = (
      <Menu
        classes={{
          paper: classes.paper,
        }}
        id='userMenu'
        disableAutoFocusItem
        anchorEl={menuAnchor}
        getContentAnchorEl={null}
        elevation={0}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        transformOrigin={{ vertical: 'top', horizontal: 'center' }}
        open={isMenuOpen}
        onClose={this.handleProfileMenuClose}
      >
        <MenuItem
          component={WrappedNavLink}
          to={isAdmin ? ROUTES.user.root.path() : ROUTES.admin.root.path()}
          className={classes.dashboardSwitchMenuItem}
        >
          { isAdmin
            ? (
              <React.Fragment>
                <ListItemIcon>
                  <DvrIcon />
                </ListItemIcon>
                {<DiverstFormattedMessage {...messages.header.dashboard} />}
              </React.Fragment>
            )
            : (
              <React.Fragment>
                <ListItemIcon>
                  <BuildIcon />
                </ListItemIcon>
                {<DiverstFormattedMessage {...messages.header.admin} />}
              </React.Fragment>
            )
          }
        </MenuItem>
        <MenuItem
          component={WrappedNavLink}
          to={ROUTES.user.show.path(user.user_id)}
          activeClassName={classes.navLinkActive}
        >
          <ListItemIcon>
            <PermIdentityIcon />
          </ListItemIcon>
          {<DiverstFormattedMessage {...messages.header.profile} />}
        </MenuItem>
        <MenuItem onClick={this.logoutBegin}>
          <ListItemIcon>
            <ExitToAppIcon />
          </ListItemIcon>
          {<DiverstFormattedMessage {...messages.header.logout} />}
        </MenuItem>
      </Menu>
    );

    return (
      <React.Fragment>
        <AppBar position={position} className={classes.appBar}>
          <Toolbar className={classes.toolbar}>
            { isAdmin
              ? (
                <IconButton
                  aria-label='Open drawer'
                  edge='start'
                  onClick={this.handleDrawerToggle}
                  className={classNames(classes.drawerToggle, classes.whiteButton)}
                >
                  <MenuIcon />
                </IconButton>
              )
              : <React.Fragment />
            }
            <Logo height='55px' withLink />
            <div className={classNames(classes.grow, classes.centerText)}>
              <Hidden xsDown>
                {!isAdmin && group ? (
                  <Typography variant='h5'>
                    {group.name}
                  </Typography>
                )
                  : (<React.Fragment />)
                }
              </Hidden>
            </div>
            <div className={classes.sectionDesktop}>
              <div className={classes.buttonSection}>
                <Permission show={isAdmin || !!adminPath}>
                  <Hidden xsDown>
                    <Link
                      component={WrappedNavLink}
                      to={isAdmin ? ROUTES.user.root.path() : adminPath && adminPath}
                    >
                      <Button
                        className={classes.dashboardSwitchButton}
                        variant='outlined'
                      >
                        { isAdmin
                          ? (
                            <span>
                              <DvrIcon className={classes.dashboardIcon} />
                              {<DiverstFormattedMessage {...messages.header.dashboard} />}
                            </span>
                          )
                          : (
                            <span>
                              <BuildIcon className={classes.adminIcon} />
                              {<DiverstFormattedMessage {...messages.header.admin} />}
                            </span>
                          )
                        }
                      </Button>
                    </Link>
                  </Hidden>
                </Permission>
                <div>
                  <IconButton
                    aria-controls={
                      isMenuOpen
                        ? 'userMenu'
                        : undefined
                    }
                    aria-haspopup='true'
                    onClick={this.handleProfileMenuOpen}
                    className={classes.whiteButton}
                  >
                    <AccountCircleIcon />
                  </IconButton>
                </div>
              </div>
            </div>
          </Toolbar>
        </AppBar>
        {renderMenu}
      </React.Fragment>
    );
  }
}

ApplicationHeader.propTypes = {
  classes: PropTypes.object,
  user: PropTypes.object,
  group: PropTypes.object,
  permissions: PropTypes.object,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
  enterprise: PropTypes.object,
  position: PropTypes.string,
  isAdmin: PropTypes.bool,
  logoutBegin: PropTypes.func,
  handleVisitAdmin: PropTypes.func,
  handleVisitHome: PropTypes.func,
};

ApplicationHeader.defaultProps = {
  position: 'absolute'
};

export function mapDispatchToProps(dispatch, ownProps) {
  return {
    logoutBegin() {
      dispatch(logoutBegin());
    },
  };
}

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
  enterprise: selectEnterprise(),
  group: selectGroup(),
  permissions: selectPermissions(),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export const StyledApplicationHeader = withStyles(styles)(ApplicationHeader);

export default compose(
  withConnect,
  withStyles(styles),
  memo,
)(ApplicationHeader);
