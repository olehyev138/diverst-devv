/*
 * LoginPage
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import AccountCircle from "@material-ui/icons/AccountCircle";
import MenuItem from "@material-ui/core/MenuItem";
import Menu from "@material-ui/core/Menu";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import IconButton from "@material-ui/core/IconButton";
import Typography from "@material-ui/core/Typography";
import { withStyles } from "@material-ui/core/styles";
import { fade } from "@material-ui/core/styles/colorManipulator";
import { push } from "connected-react-router";
import { handleLogOut, setCurrentUser } from "containers/App/actions";
import Logo from "components/Logo";
import Grid from "@material-ui/core/Grid";

import {
    makeSelectToken,
    makeSelectUser,
    makeSelectEnterprise
}
from "containers/Users/HomePage/selectors";

import defaultLogo from "images/diverst.png";
import styled from 'styled-components';
const drawerWidth = 240;
const styles = theme => ({
    root: {
        width: "100%"
    },
    grow: {
        flexGrow: 1
    },
    menuButton: {
        marginLeft: -12,
        marginRight: 20
    },
    title: {
        fontSize: 14,
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
        marginRight: theme.spacing.unit * 2,
        marginLeft: 0,
        width: "100%",
        [theme.breakpoints.up("sm")]: {
            marginLeft: theme.spacing.unit * 3,
            width: "auto"
        }
    },
    searchIcon: {
        width: theme.spacing.unit * 9,
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
        paddingTop: theme.spacing.unit,
        paddingRight: theme.spacing.unit,
        paddingBottom: theme.spacing.unit,
        paddingLeft: theme.spacing.unit * 10,
        transition: theme.transitions.create("width"),
        width: "100%",
        [theme.breakpoints.up("md")]: {
            width: 200
        }
    },
    sectionDesktop: {
        display: "none",
        [theme.breakpoints.up("md")]: {
            display: "flex"
        }
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
        transform: "scale(0.8)"
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
        padding: theme.spacing.unit * 3,
    },
    toolbar: theme.mixins.toolbar,
    nested: {
        paddingLeft: theme.spacing.unit * 4,
    },
});

export class ApplicationHeader extends React.PureComponent {

    constructor(props) {
        super(props);
        this.state = {
            anchorEl: null
        };
        this.handleLogOut = this.handleLogOut.bind(this);
        this.handleVisitAdmin = this.handleVisitAdmin.bind(this);
        this.handleVisitHome = this.handleVisitHome.bind(this);
    }

    handleLogOut() {
        this.props.handleLogOut(this.props.currentUser);
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
        const { classes, enterprise, showAdmin, position } = this.props;
        const isMenuOpen = Boolean(anchorEl);

        const renderMenu = (
            <Menu
                anchorEl={anchorEl}
                anchorOrigin={{ vertical: "top", horizontal: "right" }}
                transformOrigin={{ vertical: "top", horizontal: "right" }}
                open={isMenuOpen}
                onClose={this.handleMenuClose}
            >
                <MenuItem onClick={this.handleMenuClose}>Profile</MenuItem>
                <MenuItem onClick={this.handleLogOut}>Log Out</MenuItem>
            </Menu>
        );

        return (
            <div>
                <AppBar position={position} className={classes.appBar}>
                    <Toolbar>
                        <Logo imgClass="tiny-img" margin={20} />
                        <Typography
                            className={classes.title}
                            variant="h6"
                            color="inherit"
                            noWrap
                        >
                            {enterprise.name}
                        </Typography>
                        <div className={classes.grow} />
                        <div>
                            <Grid container direction="row" alignItems="center">
                            { showAdmin ?
                                    <div>
                                        <Grid item onClick={this.handleVisitHome}>
                                            Home
                                        </Grid>
                                        <Grid item>
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
                                        </Grid>
                                    </div>
                                    :
                                    
                                    <div>
                                        <Grid item onClick={this.handleVisitAdmin}>
                                            Admin
                                        </Grid>
                                        <Grid item>
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
                                        </Grid>
                                    </div>
                                }
                            </Grid>
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
        handleLogOut: function(token) {
            dispatch(handleLogOut(token));
            dispatch(setCurrentUser(null));
        },
        handleVisitAdmin: function() {
            dispatch(push("/admins/analytics"));
        },
        handleVisitHome: function() {
            dispatch(push("/users/home"));
        }
    };
}

const mapStateToProps = createStructuredSelector({
    token: makeSelectToken(),
    currentUser: makeSelectUser(),
    enterprise: makeSelectEnterprise()
});

const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps,
);

export default compose(
    withConnect,
)(withStyles(styles)(ApplicationHeader));
