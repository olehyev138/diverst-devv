/*
 * HomePage
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import PropTypes from "prop-types";
import { FormattedMessage } from "react-intl";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import { push } from "connected-react-router";

import injectReducer from "utils/injectReducer";
import injectSaga from "utils/injectSaga";
import messages from "./messages";
import reducer from "./reducer";
import saga from "./saga";

import { handleLogOut, setCurrentUser } from "containers/App/actions";
import {
    makeSelectToken,
    makeSelectUser,
    makeSelectEnterprise
}
from "./selectors";

import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";
import { fade } from "@material-ui/core/styles/colorManipulator";
import { withStyles } from "@material-ui/core/styles";
import Grid from "@material-ui/core/Grid";
import Card from "@material-ui/core/Card";
import CardActions from "@material-ui/core/CardActions";
import CardContent from "@material-ui/core/CardContent";
import Paper from '@material-ui/core/Paper';
import ApplicationHeader from "components/ApplicationHeader";
import HomePageLinks from "components/HomePageLinks";
import Events from "components/Events";
import News from "components/News";
import Sponsors from "components/Sponsors";

const styles = theme => ({
    root: {
        width: "100%",
        flexGrow: 1,
    },
    paper: {
        padding: theme.spacing.unit * 2,
        textAlign: 'center',
        color: theme.palette.text.secondary,
    },
    grow: {
        flexGrow: 1
    },
    title: {
        fontSize: 14,
        display: "none",
        [theme.breakpoints.up("sm")]: {
            display: "block"
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
    }
});

/* eslint-disable react/prefer-stateless-function */
export class HomePage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.handleLogOut = this.handleLogOut.bind(this);
        this.handleVisitAdmin = this.handleVisitAdmin.bind(this);
    }

    handleLogOut() {
        this.props.handleLogOut(this.props.currentUser);
    }

    handleVisitAdmin() {
        this.props.handleVisitAdmin();
    }

    state = {
        anchorEl: null,
        mobileMoreAnchorEl: null
    };

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

    componentWillMount() {}

    componentDidMount() {}

    render() {
        const { classes } = this.props;
        const bull = <span className={classes.bullet}>•</span>;

        return (
            <div className={classes.root}>
                <ApplicationHeader position="static"/>
                <HomePageLinks/>

                <Grid container spacing={24} style={{padding: 10, margin: 0, width: '100%'}}>
                    <Events />
                    <News />
                </Grid>
                
                <Grid container spacing={24} style={{padding: 10, margin: 0, width: '100%'}}>
                    <Sponsors />
                </Grid>
            </div>
        );
    }
}

HomePage.propTypes = {
    handleLogOut: PropTypes.func,
    currentUser: PropTypes.object,
    classes: PropTypes.object
};

export function mapDispatchToProps(dispatch, ownProps) {
    return {
        handleLogOut: function(token) {
            dispatch(handleLogOut(token));
            dispatch(setCurrentUser(null));
        },
        handleVisitAdmin: function() {
            dispatch(push("/admins/analytics"));
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
    mapDispatchToProps
);

const withReducer = injectReducer({ key: "home", reducer });
const withSaga = injectSaga({ key: "home", saga });

export default compose(
    withReducer,
    withSaga,
    withConnect
)(withStyles(styles)(HomePage));
