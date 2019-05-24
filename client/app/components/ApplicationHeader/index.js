import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { push } from "connected-react-router";

import { MenuItem, Menu, AppBar, Button,
  Toolbar, IconButton, Typography, ListItemIcon } from "@material-ui/core";
import AccountCircle from "@material-ui/icons/AccountCircle";
import PermIdentity from "@material-ui/icons/PermIdentity";
import ExitToApp from "@material-ui/icons/ExitToApp";
import Build from "@material-ui/icons/Build";
import SupervisorAccount from "@material-ui/icons/SupervisorAccount";
import { withStyles } from "@material-ui/core/styles";
import { fade } from "@material-ui/core/styles/colorManipulator";

import Logo from 'components/Logo';
import { logoutBegin, setUser } from "containers/App/actions";
import { createStructuredSelector } from "reselect";

import {
  selectToken,
  selectUser,
  selectEnterprise
} from 'containers/App/selectors';


import styled from 'styled-components';
const drawerWidth = 240;

const styles = theme => ({
  root: {
    width: "100%",
  },
  grow: {
    flexGrow: 1,
  },
  menuButton: {
    marginLeft: -12,
    marginRight: 20
  },
  title: {
    fontSize: 14,
    flexGrow: 1,
    display: "none",
    [theme.breakpoints.up("sm")]: {
      display: "block"
    }
  },
  search: {
    position: "relative",
    borderRadius: theme.shape.borderRadius,
    backgroundColor: fade(theme.palette.common.white, 0.15),
    "&:hover": {
      backgroundColor: fade(theme.palette.common.white, 0.25)
    },
    marginRight: theme.spacing(2),
    marginLeft: 0,
    width: "100%",
    [theme.breakpoints.up("sm")]: {
      marginLeft: theme.spacing(3),
      width: "auto"
    }
  },
  searchIcon: {
    width: theme.spacing(9),
    height: "100%",
    position: "absolute",
    pointerEvents: "none",
    display: "flex",
    alignItems: "center",
    justifyContent: "center"
  },
  inputRoot: {
    color: "inherit",
    width: "100%"
  },
  inputInput: {
    paddingTop: theme.spacing(1),
    paddingRight: theme.spacing(1),
    paddingBottom: theme.spacing(1),
    paddingLeft: theme.spacing(10),
    transition: theme.transitions.create("width"),
    width: "100%",
    [theme.breakpoints.up("md")]: {
      width: 200
    }
  },
  sectionDesktop: {
    display: "flex",
    // display: "none",
    // [theme.breakpoints.up("md")]: {
    //   display: "flex"
    // }
  },
  sectionMobile: {
    display: "flex",
    [theme.breakpoints.up("md")]: {
      display: "none"
    }
  },
  card: {
    minWidth: 275
  },
  bullet: {
    display: "inline-block",
    margin: "0 2px",
    transform: "scale(0.8)",
  },
  pos: {
    marginBottom: 12
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  drawer: {
    width: drawerWidth,
    flexShrink: 0,
  },
  drawerPaper: {
    width: drawerWidth,
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  toolbar: theme.mixins.toolbar,
  nested: {
    paddingLeft: theme.spacing(4),
  },
  paper: {
    border: '1px solid #a7a8a9',
  },
  buttonSection: {
    display: 'flex',
  },
  adminButton: {
    padding: '0px 8px',
  },
  adminIcon: {
    marginRight: 2,
    fontSize: 18,
  },
});

// TODO: rewrite as stateless component if possible
export class ApplicationHeader extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      anchorEl: null,
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

  handleProfileMenuOpen = event => {
    this.setState({ anchorEl: event.currentTarget });
  };

  handleMenuClose = () => {
    this.setState({ anchorEl: null });
    this.handleMobileMenuClose();
  };

  handleMobileMenuOpen = event => {
    this.setState({ mobileMoreAnchorEl: event.currentTarget });
  };

  handleMobileMenuClose = () => {
    this.setState({ mobileMoreAnchorEl: null });
  };

  render() {
    const { anchorEl } = this.state;
    const { classes, enterprise, position, isAdmin } = this.props;
    const isMenuOpen = Boolean(anchorEl);

    const renderMenu = (
      <Menu
        classes={{
          paper: classes.paper,
        }}
        disableAutoFocusItem
        anchorEl={anchorEl}
        getContentAnchorEl={null}
        elevation={0}
        anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
        transformOrigin={{ vertical: "top", horizontal: "center" }}
        open={isMenuOpen}
        onClose={this.handleMenuClose}
      >
        <MenuItem onClick={this.handleMenuClose}>
          <ListItemIcon>
            <PermIdentity />
          </ListItemIcon>
          Profile
        </MenuItem>
        <MenuItem onClick={this.logoutBegin}>
          <ListItemIcon>
            <ExitToApp />
          </ListItemIcon>
          Log Out
        </MenuItem>
      </Menu>
    );

    return (
      <div>
        <AppBar position={position} className={classes.appBar}>
          <Toolbar>
            <Logo imgClass="large-img" verticalPadding={20} />
            <div className={classes.grow} />
            <div className={classes.sectionDesktop}>
              <div className={classes.buttonSection}>
                <Button
                  className={classes.adminButton}
                  variant="outlined"
                  color="inherit"
                  onClick={isAdmin ? this.handleVisitHome : this.handleVisitAdmin}
                >
                  {isAdmin ?
                    <span>
                      <SupervisorAccount />
                      Dashboard
                    </span>
                    :
                    <span>
                      <Build className={classes.adminIcon} />
                      Admin
                    </span>
                  }
                </Button>
                <div>
                  <IconButton
                    aria-owns={
                      isMenuOpen
                        ? "material-appbar"
                        : undefined
                    }
                    aria-haspopup="true"
                    onClick={this.handleProfileMenuOpen}
                    color="inherit"
                  >
                    <AccountCircle />
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

export function mapDispatchToProps(dispatch, ownProps) {
  return {
    logoutBegin: function(user) {
      dispatch(logoutBegin(user));
      dispatch(setUser(null));
    },
    handleVisitAdmin: function() {
      dispatch(push("/admin/analytics"));
    },
    handleVisitHome: function() {
      dispatch(push("/user/home"));
    }
  };
}

const mapStateToProps = createStructuredSelector({
  token: selectToken(),
  user: selectUser(),
  enterprise: selectEnterprise()
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
)(withStyles(styles)(ApplicationHeader));
