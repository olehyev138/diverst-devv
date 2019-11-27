import React, { memo, useContext } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Breadcrumbs, Link, Paper, Typography } from '@material-ui/core';
import BreadcrumbSeparatorIcon from '@material-ui/icons/NavigateNext';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import RouteService from 'utils/routeHelpers';

import { customTexts } from 'utils/customTextHelpers';

const styles = theme => ({
  paper: {
    borderColor: '#DEDEDE',
    borderStyle: 'solid',
    borderWidth: 1,
    padding: theme.spacing(1, 2),
    width: 'fit-content',
    display: 'inline-block',
    marginBottom: 24,
    marginRight: 8,
  },
  breadcrumbCurrentPageText: {
    color: theme.custom.colors.offBlack,
  },
});

export function DiverstBreadcrumbs(props) {
  const { classes } = props;

  const rs = new RouteService(useContext);
  const pathNames = rs.routeData.location.pathname.split('/').filter(x => x);

  if (pathNames.length <= 1)
    return (<React.Fragment />);

  return (
    <React.Fragment>
      <Paper elevation={0} className={classes.paper}>
        <Breadcrumbs
          separator={<BreadcrumbSeparatorIcon fontSize='small' />}
          aria-label='breadcrumb'
        >
          {pathNames.map((value, index) => {
            const last = index === pathNames.length - 1;
            const to = `/${pathNames.slice(0, index + 1).join('/')}`;
            const [title, isPathPrefix] = rs.findTitleForPath({
              path: to,
              params: Object.values(rs.routeData.computedMatch.params),
              textArguments: customTexts()
            });

            if (!title)
              return undefined;

            return last || isPathPrefix ? (
              <Typography
                className={classes.breadcrumbCurrentPageText}
                key={to}
              >
                {title}
              </Typography>
            ) : (
              <Link
                component={WrappedNavLink}
                to={to}
                key={to}
              >
                {title}
              </Link>
            );
          })}
        </Breadcrumbs>
      </Paper>
    </React.Fragment>
  );
}

DiverstBreadcrumbs.propTypes = {
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstBreadcrumbs);
