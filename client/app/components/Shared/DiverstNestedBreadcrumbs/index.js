/*
  DiverstNestedBreadcrumbs :
  Used for navigation between items who may be nested inside one another.
  The nestedNavigation prop must be of the form
  { title, id }
  and must include the parents and the current item to be displayed
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation, useParams } from 'react-router-dom';
import { withStyles } from '@material-ui/core/styles';
import { Breadcrumbs, Link, Paper, Typography } from '@material-ui/core';
import BreadcrumbSeparatorIcon from '@material-ui/icons/NavigateNext';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { findTitleForPath } from 'utils/routeHelpers';

import { customTexts } from 'utils/customTextHelpers';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'components/Shared/DiverstBreadcrumbs/messages';

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


export function DiverstNestedBreadcrumbs(props) {
  const { classes } = props;
  const location = useLocation();
  const params = useParams();

  const pathNames = location.pathname.split('/').filter(x => x);

  if (pathNames.length <= 1)
    return (<React.Fragment />);

  // Transform format of previous locations
  const breadCrumbs = [];
  pathNames.forEach((currentLocation, index) => {
    if (index >= 1) {
      const [title, isPathPrefix] = findTitleForPath({
        path: (`/${breadCrumbs[index - 1].path}/${currentLocation}`),
        params: Object.values(params),
        textArguments: customTexts()
      });
      breadCrumbs.push({ path: (`${breadCrumbs[index - 1].path}/${currentLocation}`), title, isPathPrefix });
    } else {
      const [title, isPathPrefix] = findTitleForPath({ path: `/${currentLocation}`, params: Object.values(params), textArguments: customTexts() });
      breadCrumbs.push({
        path: currentLocation,
        title,
        isPathPrefix
      });
    }
  });

  const lastIndex = breadCrumbs.length - 1;
  const pathBeginning = breadCrumbs[breadCrumbs.length - 2].path;
  const parents = [];
  props.nestedNavigation.forEach((component) => {
    parents.push({ ...component, path: (`${pathBeginning}/${component.id}`) });
  });
  breadCrumbs.splice(lastIndex, 1, ...parents);

  if (props.isLoading)
    return (<React.Fragment />);

  return (
    <React.Fragment>
      <Paper elevation={0} className={classes.paper}>
        <Breadcrumbs
          separator={<BreadcrumbSeparatorIcon fontSize='small' />}
          aria-label={props.intl.formatMessage(messages.breadcrumbs, props.customTexts)}
        >
          {breadCrumbs.map((value, index) => {
            const last = index === breadCrumbs.length - 1;
            return last ? (
              <Typography
                className={classes.breadcrumbCurrentPageText}
                key={value.path}
              >
                {value.title}
              </Typography>
            ) : (
              <Link
                component={WrappedNavLink}
                to={`/${value.path}`}
                key={value.path}
              >
                {value.title}
              </Link>
            );
          })}
        </Breadcrumbs>
      </Paper>
    </React.Fragment>
  );
}

DiverstNestedBreadcrumbs.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  title: PropTypes.string,
  nestedNavigation: PropTypes.array,
  customTexts: PropTypes.object,
  intl: intlShape.isRequired
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(DiverstNestedBreadcrumbs);
