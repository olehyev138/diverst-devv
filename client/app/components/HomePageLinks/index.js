/*
 * LoginPage
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import { push } from "connected-react-router";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Button from "@material-ui/core/Button";
import { NavLink } from 'react-router-dom';
import { withTheme } from "@material-ui/core/styles";

import Dropdown from "react-bootstrap/Dropdown";
import DropdownButton from "react-bootstrap/DropdownButton";

export class HomePageLinks extends React.PureComponent {

    constructor(props) {
        super(props);
        this.onNavigate = this.onNavigate.bind(this);
    }

    onNavigate() {
        this.props.onNavigate();
    }

    render() {
        const { theme } = this.props;
        const activeColor = theme.palette.primary.main;
        
        const MyNavLinks = () => (
            <Toolbar
                style={{
                    float: "none",
                    marginLeft: "auto",
                    marginRight: "auto"
                }}
            >
                
                <Button component={NavLink} to="/users/home" activeStyle={{ color: activeColor }}>Home</Button>
                <Button component={NavLink} to="/users/campaigns" activeStyle={{ color: activeColor }}>Innovate</Button>
                <Button component={NavLink} to="/users/news" activeStyle={{ color: activeColor }}>News</Button>
                <Button component={NavLink} to="/users/events" activeStyle={{ color: activeColor }}>Events</Button>
                <Button component={NavLink} to="/users/groups" activeStyle={{ color: activeColor }}>Inclusions Networks</Button>
                <Button>Mentorship</Button>
            </Toolbar>
        );

        return (
            <div>
                <AppBar position="static" style={{ backgroundColor: "white" }}>
                    <MyNavLinks />
                </AppBar>
            </div>
        );
    }
}

export function mapDispatchToProps(dispatch, ownProps) {
    return {
        onNavigate: function() {
            dispatch(push("/users/campaigns"));
        },
    };
}

const mapStateToProps = createStructuredSelector({});

const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps
);

export default compose(
    withConnect,
)(withTheme()(HomePageLinks));
