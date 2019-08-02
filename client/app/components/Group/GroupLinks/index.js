import React, { useContext } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { AppBar, Toolbar, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function GroupLinks(props) {
  const { theme } = props;
  const activeColor = theme.palette.primary.main;
  const rs = new RouteService(useContext);

  // to={buildPath(ROUTES.group.news.index.path(), props, ['group_id'])}

  const NavLinks = () => (
    <Toolbar
      style={{
        float: 'none',
        marginLeft: 'auto',
        marginRight: 'auto'
      }}
    >
      <Button
        exact
        component={WrappedNavLink}
        to={ROUTES.group.home.path(rs.params('group_id'))}
        activeStyle={{ color: activeColor }}
      >
        Home
      </Button>
      <Button
        component={WrappedNavLink}
        to={ROUTES.group.members.index.path(rs.params('group_id'))}
        activeStyle={{ color: activeColor }}
      >
        Members
      </Button>
      <Button component={WrappedNavLink} to='events' activeStyle={{ color: activeColor }}>Events</Button>
      <Button component={WrappedNavLink} to='resources' activeStyle={{ color: activeColor }}>Resources</Button>
      { /* TODO: do this properly */ }
      <Button
        component={WrappedNavLink}
        to={ROUTES.group.news.index.path(rs.params('group_id'))}
        activeStyle={{ color: activeColor }}
      >
        News Feed
      </Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Manage</Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Plan</Button>
    </Toolbar>
  );

  return (
    <div>
      <AppBar position='static' style={{ backgroundColor: 'white' }}>
        <NavLinks />
      </AppBar>
    </div>
  );
}

GroupLinks.propTypes = {
  theme: PropTypes.object,
  computedMatch: PropTypes.shape({
    params: PropTypes.shape({
      id: PropTypes.string
    })
  }),
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
)(withTheme(GroupLinks));
