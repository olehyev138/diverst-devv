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

import injectReducer from "utils/injectReducer";
import injectSaga from "utils/injectSaga";
import messages from "./messages";
import reducer from "./reducer";
import saga from "./saga";

import { withStyles } from "@material-ui/core/styles";

import ApplicationHeader from "components/ApplicationHeader";
import HomePageLinks from "components/HomePageLinks";

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
export class NewsPage extends React.PureComponent {
    
    constructor(props) {
        super(props);
    }
    
    componentWillMount() {}

    componentDidMount() {}

    render() {
        const { classes } = this.props;

        return (
            <div className={classes.root}>
                <ApplicationHeader position="static"/>
                <HomePageLinks/>
            </div>
        );
    }
}

NewsPage.propTypes = {
    classes: PropTypes.object
};

export function mapDispatchToProps(dispatch, ownProps) {
    return {
    };
}

const mapStateToProps = createStructuredSelector({
});

const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps
);

const withReducer = injectReducer({ key: "news", reducer });
const withSaga = injectSaga({ key: "news", saga });

export default compose(
    withReducer,
    withSaga,
    withConnect
)(withStyles(styles)(NewsPage));