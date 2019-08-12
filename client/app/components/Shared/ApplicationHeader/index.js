import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { push } from 'connected-react-router';
import PropTypes from 'prop-types';
import { createStructuredSelector } from 'reselect';
import classNames from 'classnames';

import { withStyles } from '@material-ui/core/styles';
import {
  AppBar, Button, Hidden, IconButton, ListItemIcon, Menu, MenuItem, Toolbar, Typography,
} from '@material-ui/core';
import AccountCircleIcon from '@material-ui/icons/AccountCircle';
import PermIdentityIcon from '@material-ui/icons/PermIdentity';
import ExitToAppIcon from '@material-ui/icons/ExitToApp';
import BuildIcon from '@material-ui/icons/Build';
import DvrIcon from '@material-ui/icons/Dvr';
import MenuIcon from '@material-ui/icons/Menu';

import Logo from 'components/Shared/Logo/index';
import { logoutBegin, setUser } from 'containers/Shared/App/actions';

import { selectEnterprise, selectToken, selectUser } from 'containers/Shared/App/selectors';

import { selectGroup } from 'containers/Group/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  root: {
    width: '100%',
  },
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
});

export class ApplicationHeader extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      drawerOpen: props.drawerOpen,
      menuAnchor: null,
    };

    this.logoutBegin = this.logoutBegin.bind(this);
    this.handleVisitAdmin = this.handleVisitAdmin.bind(this);
    this.handleVisitHome = this.handleVisitHome.bind(this);
  }

  logoutBegin() {
    this.props.logoutBegin(this.props.user);
  }

  handleVisitAdmin() {
    this.props.handleVisitAdmin();
  }

  handleVisitHome() {
    this.props.handleVisitHome();
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
      classes, enterprise, group, position, isAdmin
    } = this.props;
    const isMenuOpen = Boolean(menuAnchor);

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
          className={classes.dashboardSwitchMenuItem}
          onClick={isAdmin ? this.handleVisitHome : this.handleVisitAdmin}
        >
          { isAdmin
            ? (
              <React.Fragment>
                <ListItemIcon>
                  <DvrIcon />
                </ListItemIcon>
              Dashboard
              </React.Fragment>
            )
            : (
              <React.Fragment>
                <ListItemIcon>
                  <BuildIcon />
                </ListItemIcon>
              Admin
              </React.Fragment>
            )
          }
        </MenuItem>
        <MenuItem onClick={this.handleProfileMenuClose}>
          <ListItemIcon>
            <PermIdentityIcon />
          </ListItemIcon>
          Profile
        </MenuItem>
        <MenuItem onClick={this.logoutBegin}>
          <ListItemIcon>
            <ExitToAppIcon />
          </ListItemIcon>
          Log Out
        </MenuItem>
      </Menu>
    );

    return (
      <div className={classes.root}>
        <AppBar position={position} className={classes.appBar}>
          <Toolbar className={classes.toolbar}>
            { isAdmin
              ? (
                <IconButton
                  color='inherit'
                  aria-label='Open drawer'
                  edge='start'
                  onClick={this.handleDrawerToggle}
                  className={classes.drawerToggle}
                >
                  <MenuIcon />
                </IconButton>
              )
              : <React.Fragment />
            }
            <Button
              size='small'
              onClick={this.handleVisitHome}
            >
              <Logo imgClass='large-img' verticalPadding={20} />
            </Button>
            <div className={classNames(classes.grow, classes.centerText)}>
              { group ? (
                <Typography variant='h5'>
                  {group.name}
                </Typography>
              )
                : (<React.Fragment />)
              }
            </div>
            <div className={classes.sectionDesktop}>
              <div className={classes.buttonSection}>
                <Hidden xsDown>
                  <Button
                    className={classes.dashboardSwitchButton}
                    variant='outlined'
                    color='inherit'
                    onClick={isAdmin ? this.handleVisitHome : this.handleVisitAdmin}
                  >
                    { isAdmin
                      ? (
                        <span>
                          <DvrIcon className={classes.dashboardIcon} />
                        Dashboard
                        </span>
                      )
                      : (
                        <span>
                          <BuildIcon className={classes.adminIcon} />
                        Admin
                        </span>
                      )
                    }
                  </Button>
                </Hidden>
                <div>
                  <IconButton
                    aria-controls={
                      isMenuOpen
                        ? 'userMenu'
                        : undefined
                    }
                    aria-haspopup='true'
                    onClick={this.handleProfileMenuOpen}
                    color='inherit'
                  >
                    <AccountCircleIcon />
                  </IconButton>
                </div>
              </div>
            </div>
          </Toolbar>
        </AppBar>
        {renderMenu}
      </div>
    );
  }
}

ApplicationHeader.propTypes = {
  classes: PropTypes.object,
  user: PropTypes.object,
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
    logoutBegin(user) {
      dispatch(logoutBegin(user));
    },
    handleVisitAdmin() {
      dispatch(push(ROUTES.admin.root.path()));
    },
    handleVisitHome() {
      dispatch(push(ROUTES.user.root.path()));
    }
  };
}

const mapStateToProps = createStructuredSelector({
  token: selectToken(),
  user: selectUser(),
  enterprise: selectEnterprise(),
  group: selectGroup(),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export const StyledApplicationHeader = withStyles(styles)(ApplicationHeader);

export default compose(
  withConnect,
  withStyles(styles),
)(ApplicationHeader);
