/**
 *
 * Group Categorize Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import { buildValues } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Divider, Box, Typography, TextField
} from '@material-ui/core';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupCategorizeFormInner({ classes, handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <React.Fragment>
      <Grid container spacing={3} justify='space-between'>
        <Grid item>
          <Typography color='primary' variant='h5'>
            {values.name}
          </Typography>
        </Grid>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.categories.index.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.allcategories} />
          </Button>
        </Grid>
      </Grid>
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
                    value={values.children[i].category}
                    options={props.categories}
                    onChange={(value) => {
                      setFieldValue(`children[${i}].group_category_id`, value.value);
                      setFieldValue(`children[${i}].category`, value);
                    }
                    }
                  />
                </Grid>
              ))}
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.save} />
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
        props.groupAction(values);
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
  categories: PropTypes.array,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupCategorizeForm);
