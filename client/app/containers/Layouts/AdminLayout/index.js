import React, { memo } from 'react';
import { Route } from 'react-router';
import { compose } from "redux";

import Container from "@material-ui/core/Container";
import AdminLinks from 'components/AdminLinks';
import { withStyles } from "@material-ui/core/styles";
import AuthenticatedLayout from "../AuthenticatedLayout";
import {createStructuredSelector} from "reselect";
import PropTypes from "prop-types";

const styles = theme => ({
  flex: {
    display: 'flex',
  },
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

export class AdminLayout extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      drawerOpen: false,
    };
  }

  drawerToggleCallback = (drawerStatus) => {
    this.setState({ drawerOpen: drawerStatus });
  };

  render() {
    const { classes, ...other } = this.props;
    const Component = this.props.component;

    return (
      <AuthenticatedLayout drawerToggleCallback={this.drawerToggleCallback} drawerOpen={this.state.drawerOpen} position='absolute' isAdmin component={matchProps => (
        <div className={classes.flex}>
          <AdminLinks drawerToggleCallback={this.drawerToggleCallback} drawerOpen={this.state.drawerOpen} {...matchProps} />

          <Container maxWidth='xl'>
            <div className={classes.content}>
              <div className={classes.toolbar} />
              <Component {...other} />
            </div>
          </Container>
        </div>
      )}/>
    );
  }
};

export default withStyles(styles)(AdminLayout);
