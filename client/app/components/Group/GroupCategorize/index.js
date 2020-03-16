/**
 *
 * Group Categorize Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Divider, Box,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { push } from 'connected-react-router';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupCategorizeFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.categories.index.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            All categories
          </Button>
        </Grid>
      </Grid>
      <Box mb={3} />
      <Card>
        <CardContent>
          <Field
            component={Select}
            fullWidth
            disabled={props.isCommitting}
            id='name'
            name='name'
            margin='normal'
            label='Categorize Group'
            value={values.name}
            options={props.selectGroups}
            onChange={value => props.changePage(value.value)}
            onBlur={() => setFieldTouched('name', true)}
          />
        </CardContent>
      </Card>
      <Box mb={3} />
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.group}>
        <Card>
          <Form>
            <CardContent>
              {values.children && values.children.map((subgroup, i) => (
                <Grid item key={subgroup.id} xs={12}>
                  <Field
                    component={Select}
                    fullWidth
                    disabled={props.isCommitting}
                    id='name'
                    name='name'
                    margin='normal'
                    label={subgroup.name}
                    value={values.children[i].categroy}
                    options={props.categories}
                    onChange={value => setFieldValue(`children[${i}]['categroy']`, value)}
                    // onBlur={() => setFieldTouched('name', true)}
                  />
                </Grid>
              ))}
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
              <Button
                disabled={props.isCommitting}
                to={ROUTES.admin.manage.groups.index.path()}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function GroupCategorizeForm(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    name: { default: '' },
    children: { default: [] }

  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <GroupCategorizeFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupCategorizeForm.propTypes = {
  edit: PropTypes.bool,
  groupAction: PropTypes.func,
  group: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

GroupCategorizeFormInner.propTypes = {
  edit: PropTypes.bool,
  group: PropTypes.object,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  categories: PropTypes.array,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  changePage: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupCategorizeForm);
